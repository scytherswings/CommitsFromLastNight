namespace :BitBucketAPI do

  desc 'Fetches the lastest commits based on the newest timestamp found in the database.'
  task fetch_latest_commits: :environment do
    # Rails.logger = Logger.new(STDOUT)

    config_file = YAML.load_file('config.yml')
    bitbucket = BitBucket.new basic_auth: config_file['username'] + ':' + config_file['password']

    Rails.logger.info 'Starting to fetch data from BitBucket for repos and commits using the username: ' + config_file['username']
    repos = bitbucket.repos.list

    repos.each do |repo|
      Rails.logger.info 'Working on repo: ' + repo['slug']

      begin
        repository = Repository.find_or_create_by!(name: repo['slug'])
        grab_commits_from_bitbucket(100, bitbucket, repository, repo['owner'])

      rescue BitBucket::Error => error
        Rails.logger.error "An error occurred trying to query the changesets for #{repo['slug']}. Error was #{error}"
        next
      end
    end

    Rails.logger.info 'Fetching latest commits finished'
  end

  desc 'Fetches up to [n] old commits'
  task :fetch_old_commits, [:commits_to_grab] => :environment do |_, args|
    puts "I grabbed old stuff:  #{args[:commits_to_grab]}"
  end

  def grab_commits_from_bitbucket(commits_to_get, bitbucket, repository, repo_owner)
    if commits_to_get <= 0
      Rails.logger.debug 'grab_commits_from_bitbucket was called with commits_to_get of 0 or less. Returning.'
      return
    end

    commits_to_get = commits_to_get < 50 ? commits_to_get : 50

    Rails.logger.debug "Fetching #{commits_to_get} commits from #{repository.name}."

    params = {'limit': commits_to_get}
    oldest_commit = find_oldest_commit_in_repo(repository)

    if oldest_commit
      params = {'limit': commits_to_get, 'start': oldest_commit.sha}
    end

    changeset_list = bitbucket.repos.changesets.list(repo_owner, repository.name, params)
    available_commits_count = changeset_list['count']
    add_commits_to_db(changeset_list, bitbucket, repository)

    total_records_fetched = changeset_list['changesets'].count

    if commits_to_get < 50 && total_records_fetched < commits_to_get
      Rails.logger.debug "The number of records received: #{total_records_fetched} for repository: #{repository.name} was less than the number asked for: #{commits_to_get}. There are no more commits to grab."
      return
    end

    if total_records_fetched < commits_to_get && ((commits_to_get - total_records_fetched) < available_commits_count)
      grab_commits_from_bitbucket(commits_to_get - total_records_fetched, bitbucket, repository, repo_owner)
    end
  end

  def add_commits_to_db(changeset_list, bitbucket, repository)
    changeset_list['changesets'].each do |changeset|
      user = find_or_create_new_user changeset

      find_or_set_user_avatar_uri bitbucket, user

      Commit.create(sha: changeset['raw_node'], message: changeset['message'],
                    utc_commit_time: changeset['utctimestamp'], branch_name: changeset['branch'],
                    user: user, repository: repository)
    end
  end

  def find_oldest_commit_in_repo(repo)
    commits_from_repo = Commit.where(repository_id: repo.id).order('utc_commit_time ASC')
    commits_from_repo.first
  end


  def find_or_create_new_user(changeset)
    account_name = changeset['author']
    user = User.find_or_create_by!(account_name: account_name) #Don't cache this because it will cause excess api calls for a new user's avatar_uri until it expires


    author_name = /\A(?:(?!\s<.*>\z).)+/.match(changeset['raw_author']).to_s
    email = /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i.match(changeset['raw_author']).to_s.downcase

    if /[\W]/.match account_name
      Rails.logger.fatal "Username: #{account_name} was found to contain a non-word character or number! WTF. #{changeset.to_json}"
      exit! 1
    end

    Rails.cache.fetch("users/#{account_name}/author_name/#{author_name}", expire_in: 30.seconds) do
      UserName.create(name: author_name)
    end

    Rails.cache.fetch("users/#{account_name}/email_address/#{email}", expire_in: 30.seconds) do
      EmailAddress.create(email: email, user: user)
    end

    user
  end

  def find_or_set_user_avatar_uri(bitbucket, user)
    if user.account_name && !user.avatar_uri
      Rails.logger.debug "Found a user: #{user.account_name} whose avatar_uri was: #{user.avatar_uri}. Querying profile for avatar_uri."

      user_profile = Rails.cache.fetch("users/#{user.account_name}/avatar_uri", expire_in: 30.seconds) do
        Rails.logger.debug "User #{user.account_name}'s profile was not found in the cache. Querying BitBucket.'"
        bitbucket.users.account.profile(user.account_name)
      end

      avatar_uri = user_profile['user']['avatar']

      Rails.logger.debug "User #{user.account_name}'s avatar_uri is going to be updated with: #{avatar_uri}"
      user.update!(avatar_uri: avatar_uri)
    end
  end
end
