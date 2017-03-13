module Importers
  class Bitbucket
    attr_accessor :logger

    def initialize(logger = Sidekiq.logger)
      @logger ||= logger
      create_bitbucket_client
    end

    def create_bitbucket_client
      default_config_file = Rails.root.join 'config.yml'
      if File.exist? default_config_file
        bb_config = YAML.load_file(default_config_file)
        unless bb_config
          logger.warn "The bitbucket config file: #{default_config_file} was empty. Maybe it shouldn't be?"
        end
      else
        bb_config = {}
      end
      bb_config['username'] ||= ENV['BB_USERNAME']
      bb_config['password'] ||= ENV['BB_PASSWORD']
      logger.debug {"bb_config: #{bb_config}"}
      logger.info { 'Starting to fetch data from BitBucket using the username: ' + bb_config['username'] }
      @bitbucket = BitBucket.new basic_auth: bb_config['username'] + ':' + bb_config['password']
    end

    def fetch_latest_commits
      repositories = Repository.all.shuffle

      repositories.each do |repo|
        logger.info { "Fetching latest commits for repo: #{repo.owner}:#{repo.name}." }
        #get newest sha
        newest_sha = find_newest_commit_in_repo(repo.id)
        fetch_commits_from_bitbucket(repo, newest_sha)
      end

      logger.info { 'Fetching latest commits finished' }
    end

    def fetch_commits_from_bitbucket(repo, newest_sha, starting_sha=nil, attempts=10)
      if attempts <= 0
        logger.warn { "Maximum retries hit for repo: #{repo.name}. Stopping queries for latest commits. Did someone rebase the repo? The history for this repo will be incomplete since the history has now been broken." }
        return
      end

      if starting_sha
        params = {'limit': 50, 'start': starting_sha}
      else
        params = {'limit': 50}
      end


      #query repo
      begin
        changeset_list = @bitbucket.repos.changesets.list(repo.owner, repo.name, params)
      rescue BitBucket::Error::BitBucketError => error
        logger.error { "An error occurred trying to query the changesets for repo: #{repo.name}. Error was #{error}" }
        return
      end

      process_changeset_list(changeset_list, repo)
      #is newest sha in response?
      if newest_sha_is_in_response?(newest_sha, changeset_list)
        #yes: stop
        logger.debug { "Finished getting lastest commits for repo: #{repo.name}" }
        return
      end

      if changeset_list['changesets'].size < 50
        logger.debug { "Repo: #{repo.name} returned less than 50 commits. Moving on to next repo." }
        return
      end

      oldest_recent_sha_fetched = find_oldest_sha_in_changeset(changeset_list)
      #no: continue until max commits have been added.
      attempts -= 1
      logger.debug { "Repo: #{repo.name} has more unfetched commits to get. Querying up to #{attempts} more times." }
      fetch_commits_from_bitbucket(repo, newest_sha, oldest_recent_sha_fetched, attempts)
    end

    def find_oldest_sha_in_changeset(changeset_list)
      changeset_list['changesets'].sort_by { |changeset| changeset['utctimestamp'].to_datetime }.first['raw_node']
    end

    def newest_sha_is_in_response?(newest_sha, changeset_list)
      changeset_list['changesets'].map { |changeset| changeset['raw_node'].to_s }.include? newest_sha
    end

    def fetch_all_repositories
      log_level = Rails.env == 'production' ? Logger::WARN : Logger::DEBUG
      ActiveRecord::Base.logger.silence(log_level) do
        @bitbucket.repos.list do |repo|
          logger.info { "Fetching historical commits for repo: #{repo['owner']}:#{repo['slug']}." }
          begin
            repository = Repository.find_or_create_by(name: repo['slug'].to_s.downcase, owner: repo['owner'].to_s) do |create|
              create.description = repo['description'].to_s
              create.avatar_uri = repo['logo'].to_s
              # create.resource_uri = 'https://bitbucket.org/' + repo['resource_uri'].to_s
            end

            if repository.avatar_uri.blank?
              avatar_uri = repo['logo']
              avatar_uri.gsub!(/\/avatar\/\d+\//, '/avatar/96/')
              logger.debug { "Found a repo: #{repository.name} whose avatar_uri was empty or nil. Setting it to the API value." }
              repository.update!(avatar_uri: avatar_uri)
            end
            repository.update(description: repo['description'].to_s)

            downcased_language = repo['language'].to_s.downcase
            if downcased_language.blank?
              logger.debug { "The API returned a blank language for repo: #{repository.name}. This repo will not be tagged with any languages." }
            else
              language = Word.find_or_create_by!(value: downcased_language)
              RepositoryLanguage.find_or_create_by(repository: repository, word: language)
            end

          rescue ActiveRecord::RecordNotUnique => e
            logger.error { "ActiveRecord returned an error for repository: #{repository.name}. Error: #{e}" }
            retry
          end
        end
      end
    end

    def fetch_old_commits(commits_to_grab_from_each_repo)
      commits_to_get = Integer(commits_to_grab_from_each_repo)

      log_level = Rails.env == 'production' ? Logger::WARN : Logger::DEBUG

      ActiveRecord::Base.logger.silence(log_level) do

        repositories = Repository.all.shuffle

        repositories.each do |repository|
          logger.info { "Working on repo: #{repository.owner}:#{repository.name}." }

          begin
            if repository.first_commit_sha
              logger.info { "The first_commit_sha was set for #{repository.name}. Not querying further." }
              next
            end

            grab_commits_from_bitbucket(commits_to_get, repository)

          rescue BitBucket::Error => error
            logger.error { "An error occurred trying to query the changesets for #{repository['slug']}. Error was #{error}" }
            next
          end
        end

        logger.info { 'Fetching old commits finished' }
      end
    end

    def grab_commits_from_bitbucket(commits_to_get, repository)
      if commits_to_get <= 0
        logger.debug { 'grab_commits_from_bitbucket was called with commits_to_get of 0 or less. Returning.' }
        return
      end
      commits_to_get_from_api = commits_to_get < 50 ? commits_to_get : 50
      oldest_commit = find_oldest_commit_in_repo(repository.id)

      if oldest_commit
        logger.debug { "A commit was found in repo: #{repository.name}. Using it to query history." }
        params = {'limit': commits_to_get_from_api, 'start': oldest_commit}
      else
        params = {'limit': commits_to_get_from_api}
      end

      begin
        logger.debug { "Fetching #{commits_to_get_from_api} commits from #{repository.owner}:#{repository.name}." }

        changeset_list = @bitbucket.repos.changesets.list(repository.owner, repository.name, params)
      rescue BitBucket::Error::BitBucketError => error
        logger.warn { "Query to get changesets from #{repository.name} resulted in an error: #{error}." }
        return
      end

      available_commits_count = changeset_list['count']
      process_changeset_list(changeset_list, repository)

      total_records_fetched = changeset_list['changesets'].count
      #something still isn't quite right with this logic. It needs tests.
      # if less than the desired amount are retrieved, it will query one at a time until it gets below 50. then it stops. broken.
      if (commits_to_get < 50) && (total_records_fetched < commits_to_get)
        logger.debug { "The number of records received: #{total_records_fetched} for repository: #{repository.name} was less than the number asked for: #{commits_to_get}. There are no more commits to grab." }
        earliest_commit_sha = find_oldest_commit_in_repo(repository.id)
        unless earliest_commit_sha
          logger.error { "No commits were found for repository: #{repository.name}. There should have been commits since BitBucket was queried for them or something." }
          return
        end
        repository.update!(first_commit_sha: earliest_commit_sha)
        logger.info { "The repository: #{repository.name} has had the first_commit_sha set. This will prevent historical queries on this repo from being run from now on." }
        return
      end

      more_commits_are_available = total_records_fetched < commits_to_get && ((commits_to_get - total_records_fetched) < available_commits_count)

      if more_commits_are_available
        remaining_commits_to_get = commits_to_get - total_records_fetched
        logger.debug { "More commits were found to be available for repository: #{repository.name}. Asking for #{remaining_commits_to_get} more." }
        grab_commits_from_bitbucket(remaining_commits_to_get, repository)
      end
    end

    def add_commit_to_db(changeset, user, repository)
      message = changeset['message'].to_s.gsub(/\s+/, ' ').strip

      begin
        return Commit.find_or_create_by(sha: changeset['raw_node'].to_s, repository: repository) do |create_commit|
          create_commit.utc_commit_time = changeset['utctimestamp']
          create_commit.user = user
          create_commit.message = message
          # create_commit.resource_uri = changeset['resource_uri'].to_s
        end
      rescue ActiveRecord::RecordNotUnique
        retry
      end
    end

    def process_changeset_list(changeset_list, repository)
      changeset_list['changesets'].each do |changeset|
        user = find_or_create_new_user(changeset)

        find_or_set_user_avatar_uri(user)

        add_commit_to_db(changeset, user, repository)
      end
    end

    def find_oldest_commit_in_repo(repo_id)
      Commit.where(repository_id: repo_id).order('utc_commit_time ASC').pluck(:sha).first
    end

    def find_newest_commit_in_repo(repo_id)
      Commit.where(repository_id: repo_id).order('utc_commit_time DESC').pluck(:sha).first
    end

    def find_or_create_new_user(changeset)
      account_name = changeset['author'].to_s
      begin
        user = User.find_or_create_by!(account_name: account_name) #do |create_user| #Don't cache this because it will cause excess api calls for a new user's avatar_uri until it expires
          # create_user.resource_uri = changeset['resource_uri'].to_s
          #end
      rescue ActiveRecord::RecordNotUnique
        retry
      end

      email = /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i.match(changeset['raw_author']).to_s.downcase

      Rails.cache.fetch("users/#{account_name.slice 0..32}/email_address/#{email.slice 0..32}", expires_in: 120.seconds) do
        EmailAddress.create(email: email, user: user)
      end

      user
    end

    def find_or_set_user_avatar_uri(user)
      if user.account_name && !user.avatar_uri
        logger.debug { "Found a user: #{user.account_name} whose avatar_uri was empty or nil. Querying profile for avatar_uri." }

        begin
          user_to_query = URI.encode(user.account_name)
          user_profile= @bitbucket.users.account.profile(user_to_query)

        rescue BitBucket::Error::NotFound
          logger.warn { "Query looking for #{user_to_query} resulted in a 404. Setting avatar to the default." }
          user.update(avatar_uri: 'https://bitbucket.org/account/unknown/avatar/96/?ts=0')
          return
        end

        avatar_uri = user_profile['user']['avatar']
        avatar_uri.gsub!(/\/avatar\/\d+\//, '/avatar/96/')
        logger.debug { "User #{user.account_name}'s avatar_uri is going to be updated with: #{avatar_uri}" }
        user.update!(avatar_uri: avatar_uri)
      end
    end
  end
end