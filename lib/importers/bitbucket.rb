module Importers
  class Bitbucket
    def self.fetch_latest_commits
      repositories = Rails.cache.fetch('repositories', expires_in: 60.seconds) do
        Sidekiq.logger.debug { 'Cache for repositories was empty, querying repositories from database.' }
        Repository.all
      end

      config_file = YAML.load_file('config.yml')
      bitbucket = BitBucket.new basic_auth: config_file['username'] + ':' + config_file['password']

      Sidekiq.logger.info { 'Starting to fetch commits from BitBucket for known repositories using the username: ' + config_file['username'] }
      Sidekiq.logger.info { 'Fetching latest commits finished' }
    end

    def self.fetch_all_repositories
      repos = nil
      start = Time.now
      Sidekiq.logger.debug { 'Requesting repositories from BitBucket.' }

      Rails.env == 'production' ? log_level = Logger::WARN : log_level = Logger::DEBUG
      ActiveRecord::Base.logger.silence(log_level) do
        config_file = YAML.load_file('config.yml')
        bitbucket = BitBucket.new basic_auth: config_file['username'] + ':' + config_file['password']
        repos = bitbucket.repos.list do |repo|
          Sidekiq.logger.info { "Working on repo: #{repo['owner']}:#{repo['slug']}." }
          Repository.create(name: repo['slug'].to_s, owner: repo['owner'].to_s)
        end
      end
      Sidekiq.logger.debug { 'Requesting repositories finished.' }
      end_time = Time.now
      Sidekiq.logger.debug { "Fetching #{repos.size} repos took: #{(end_time-start).round(2)} seconds." }
    end

    def self.fetch_old_commits(commits_to_grab_from_each_repo)
      commits_to_get = Integer(commits_to_grab_from_each_repo)

      config_file = YAML.load_file('config.yml')
      bitbucket = BitBucket.new basic_auth: config_file['username'] + ':' + config_file['password']
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
        Sidekiq.logger.debug { "Fetching #{commits_to_get} commits from #{repository.owner}:#{repository.name}." }
        changeset_list = bitbucket.repos.changesets.list(repository.owner, repository.name, params)
      rescue StandardError => error
        Sidekiq.logger.warn { "Query to get changesets from #{repository.name} resulted in an error: #{error}" }
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
        earliest_commit_sha = earliest_commit.sha
        repository.update!(first_commit_sha: earliest_commit_sha)
        Sidekiq.logger.info { "The repository: #{repository.name} has had the first_commit_sha set to #{repository.first_commit_sha}. This will prevent historical queries on this repo from being run from now on." }
        return
      end

      more_commits_are_available = total_records_fetched < commits_to_get && ((commits_to_get - total_records_fetched) < available_commits_count)
      if more_commits_are_available
        self.grab_commits_from_bitbucket(commits_to_get - total_records_fetched, bitbucket, repository)
      end
    end

    def self.add_commits_to_db(changeset_list, bitbucket, repository)
      changeset_list['changesets'].each do |changeset|
        user = find_or_create_new_user(changeset)

        find_or_set_user_avatar_uri(bitbucket, user)
        begin
          commit = Commit.find_or_create_by(sha: changeset['raw_node'], message: changeset['message'],
                                            utc_commit_time: changeset['utctimestamp'], branch_name: changeset['branch'],
                                            user: user, repository: repository)

          ExecuteFilters.perform_async(commit.id)
        rescue ActiveRecord::RecordNotUnique => e
          Sidekiq.logger.error { "Commit with sha: #{changeset['raw_node']} is already in the database! Are you trying to run the filter import multi-threaded? Error was: #{e}" }
        end
      end
    end

    def self.find_oldest_commit_in_repo(repo_id)
      Commit.where(repository_id: repo_id).order('utc_commit_time ASC').first
    end

    def self.find_or_create_new_user(changeset)
      account_name = changeset['author'].to_s
      user = User.find_or_create_by(account_name: account_name) #Don't cache this because it will cause excess api calls for a new user's avatar_uri until it expires

      email = /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i.match(changeset['raw_author']).to_s.downcase

      Rails.cache.fetch("users/#{account_name.slice 0..15}/email_address/#{email.slice 0..15}", expires_in: 120.seconds) do
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
          user.update(avatar_uri: 'https://bitbucket.org/account/unknown/avatar/48/?ts=0')
          return
        end

        avatar_uri = user_profile['user']['avatar']
        avatar_uri.gsub!(/\/avatar\/32\//, '/avatar/48/')
        Sidekiq.logger.debug { "User #{user.account_name}'s avatar_uri is going to be updated with: #{avatar_uri}" }
        user.update!(avatar_uri: avatar_uri)
      end
    end
  end
end