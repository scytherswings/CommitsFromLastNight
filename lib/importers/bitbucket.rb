module Importers
  class Bitbucket

    def self.create_bitbucket_client
      config_file = YAML.load_file('config.yml')
      BitBucket.new basic_auth: config_file['username'] + ':' + config_file['password']
    end

    def self.fetch_latest_commits
      repositories = Rails.cache.fetch('repositories', expires_in: 60.seconds) do
        Sidekiq.logger.debug { 'Cache for repositories was empty, querying repositories from database.' }
        Repository.all
      end

      bitbucket = create_bitbucket_client

      Sidekiq.logger.info { 'Starting to fetch commits from BitBucket for known repositories using the username: ' + config_file['username'] }
      Sidekiq.logger.info { 'Fetching latest commits finished' }
    end

    def self.fetch_all_repositories
      repos = nil
      start = Time.now
      Sidekiq.logger.debug { 'Requesting repositories from BitBucket.' }

      log_level = Rails.env == 'production' ? Logger::WARN : Logger::DEBUG
      ActiveRecord::Base.logger.silence(log_level) do
        bitbucket = create_bitbucket_client
        repos = bitbucket.repos.list do |repo|
          Sidekiq.logger.info { "Working on repo: #{repo['owner']}:#{repo['slug']}." }
          begin
            if repo['name']
              name = repo['name']
            else
              name = repo['slug']
            end

            repository = Repository.find_or_create_by(name: name.to_s.downcase, owner: repo['owner'].to_s) do |create|
              create.description = repo['description'].to_s
              create.image_uri = repo['logo'].to_s
              create.resource_uri = repo['resource_uri'].to_s
            end

            if repository.image_uri.blank?
              avatar_uri = repo['logo']
              avatar_uri.gsub!(/\/avatar\/\d+\//, '/avatar/96/')
              Sidekiq.logger.debug { "Found a repo: #{repository.name} whose image_uri was empty or nil. Setting image_uri to one retrieved from API." }
              repository.update!(image_uri: avatar_uri)
            end
            repository.update(description: repo['description'].to_s)

            downcased_language = repo['language'].to_s.downcase
            if downcased_language.blank?
              Sidekiq.logger.warn { "The API returned a blank language for repo: #{repository.name}. This repo will not be tagged with any languages!" }
            else
              language = Word.find_or_create_by!(value: downcased_language)
              RepositoryLanguage.find_or_create_by(repository: repository, word: language)
            end

          rescue ActiveRecord::RecordNotUnique => e
            Sidekiq.logger.error { "ActiveRecord returned an error for repository: #{repository.name}. Error: #{e}" }
            retry
          end
        end
      end
      Sidekiq.logger.debug { 'Requesting repositories finished.' }
      end_time = Time.now
      Sidekiq.logger.debug { "Fetching #{repos.size} repos took: #{(end_time-start).round(2)} seconds." }
    end

    def self.fetch_old_commits(commits_to_grab_from_each_repo)
      commits_to_get = Integer(commits_to_grab_from_each_repo)

      bitbucket = create_bitbucket_client
      ActiveRecord::Base.logger.silence(Logger::WARN) do
        Sidekiq.logger.info { 'Starting to fetch data from BitBucket for repos and commits using the username: ' + config_file['username'] }
        repositories = Repository.all

        repositories.each do |repository|
          Sidekiq.logger.info { "Working on repo: #{repository.owner}:#{repository.name}." }

          begin
            if repository.first_commit_sha
              Sidekiq.logger.info { "The first_commit_sha was set for #{repository.name}. Not querying further." }
              next
            end

            grab_commits_from_bitbucket(commits_to_get, bitbucket, repository)

          rescue BitBucket::Error => error
            Sidekiq.logger.error { "An error occurred trying to query the changesets for #{repository['slug']}. Error was #{error}" }
            next
          end
        end

        Sidekiq.logger.info { 'Fetching old commits finished' }
      end
    end

    def self.grab_commits_from_bitbucket(commits_to_get, bitbucket, repository)
      if commits_to_get <= 0
        Sidekiq.logger.debug { 'grab_commits_from_bitbucket was called with commits_to_get of 0 or less. Returning.' }
        return
      end
      commits_to_get = commits_to_get < 50 ? commits_to_get : 50

      oldest_commit = find_oldest_commit_in_repo(repository.id)

      if oldest_commit
        Sidekiq.logger.debug { "A commit was found in repo: #{repository.name}. Using this commit's sha to query from: #{oldest_commit.sha}." }
        params = {'limit': commits_to_get, 'start': oldest_commit.sha}
      else
        params = {'limit': commits_to_get}
      end

      begin
        retries_left ||= 2
        Sidekiq.logger.debug { "Fetching #{commits_to_get} commits from #{repository.owner}:#{repository.name}." }
        changeset_list = bitbucket.repos.changesets.list(repository.owner, repository.name, params)
      rescue StandardError => error
        retries_left -= 1
        Sidekiq.logger.warn { "Query to get changesets from #{repository.name} resulted in an error: #{error}. Retries left: #{retries_left}" }
        retry if retries_left > 0
        return
      end

      available_commits_count = changeset_list['count']
      add_commits_to_db(changeset_list, bitbucket, repository)

      total_records_fetched = changeset_list['changesets'].count

      if (commits_to_get < 50) && (total_records_fetched < commits_to_get)
        Sidekiq.logger.debug { "The number of records received: #{total_records_fetched} for repository: #{repository.name} was less than the number asked for: #{commits_to_get}. There are no more commits to grab." }
        earliest_commit = find_oldest_commit_in_repo(repository.id)
        unless earliest_commit
          Sidekiq.logger.error { "No commits were found for repository: #{repository.name}. There should have been commits since BitBucket was queried for them or something." }
          return
        end
        repository.update!(first_commit_sha: earliest_commit.sha)
        Sidekiq.logger.info { "The repository: #{repository.name} has had the first_commit_sha set to #{repository.first_commit_sha}. This will prevent historical queries on this repo from being run from now on." }
        return
      end

      more_commits_are_available = total_records_fetched < commits_to_get && ((commits_to_get - total_records_fetched) < available_commits_count)

      if more_commits_are_available
        remaining_commits_to_get = commits_to_get - total_records_fetched
        Sidekiq.logger.debug { "More commits were found to be available for repository: #{repository.name}. Asking for #{remaining_commits_to_get} more." }
        self.grab_commits_from_bitbucket(remaining_commits_to_get, bitbucket, repository)
      end
    end

    def self.add_commits_to_db(changeset_list, bitbucket, repository)
      changeset_list['changesets'].each do |changeset|
        user = find_or_create_new_user(changeset)

        find_or_set_user_avatar_uri(bitbucket, user)

        message = changeset['message'].to_s.gsub(/\s+/, ' ').strip

        begin
          commit = Commit.find_or_create_by(sha: changeset['raw_node'].to_s,
                                            message: message,
                                            utc_commit_time: changeset['utctimestamp'],
                                            resource_uri: changeset['resource_uri'].to_s,
                                            user: user,
                                            repository: repository)
        rescue ActiveRecord::RecordNotUnique
          retry
        end

        ExecuteFilters.perform_async(commit.id)
      end
    end

    def self.find_oldest_commit_in_repo(repo_id)
      Commit.where(repository_id: repo_id).order('utc_commit_time ASC').first
    end

    def self.find_or_create_new_user(changeset)
      account_name = changeset['author'].to_s
      begin
        user = User.find_or_create_by(account_name: account_name, resource_uri: changeset['resource_uri'].to_s) #Don't cache this because it will cause excess api calls for a new user's avatar_uri until it expires
      rescue ActiveRecord::RecordNotUnique
        retry
      end

      email = /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i.match(changeset['raw_author']).to_s.downcase

      Rails.cache.fetch("users/#{account_name.slice 0..32}/email_address/#{email.slice 0..32}", expires_in: 120.seconds) do
        EmailAddress.create(email: email, user: user)
      end

      user
    end

    def self.find_or_set_user_avatar_uri(bitbucket, user)
      if user.account_name && !user.avatar_uri
        Sidekiq.logger.debug { "Found a user: #{user.account_name} whose avatar_uri was empty or nil. Querying profile for avatar_uri." }

        begin
          user_to_query = URI.encode(user.account_name)
          user_profile= bitbucket.users.account.profile(user_to_query)

        rescue BitBucket::Error::NotFound
          Sidekiq.logger.warn { "Query looking for #{user_to_query} resulted in a 404. Setting avatar to the default." }
          user.update(avatar_uri: 'https://bitbucket.org/account/unknown/avatar/96/?ts=0')
          return
        end

        avatar_uri = user_profile['user']['avatar']
        avatar_uri.gsub!(/\/avatar\/\d+\//, '/avatar/96/')
        Sidekiq.logger.debug { "User #{user.account_name}'s avatar_uri is going to be updated with: #{avatar_uri}" }
        user.update!(avatar_uri: avatar_uri)
      end
    end
  end
end