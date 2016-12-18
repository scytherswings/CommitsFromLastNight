namespace :BitBucketAPI do

  desc 'Fetches the lastest commits based on the newest timestamp found in the database.'
  task fetch_latest_commits: :environment do
    repositories = Rails.cache.fetch('repositories', expire_in: 60.seconds) do
      Rails.logger.debug 'Cache for repositories was empty, querying repositories from database.'
      Repository.all
    end

    config_file = YAML.load_file('config.yml')
    bitbucket = BitBucket.new basic_auth: config_file['username'] + ':' + config_file['password']

    Rails.logger.info 'Starting to fetch commits from BitBucket for known repositories using the username: ' + config_file['username']




    Rails.logger.info 'Fetching latest commits finished'
  end

  desc 'Fetches up to [n] old commits'
  task :fetch_old_commits, [:commits_to_grab_from_each_repo] => :environment do |_, args|
    puts "I grabbed old stuff:  #{args[:commits_to_grab_from_each_repo]}"

    commits_to_get = args[:commits_to_grab_from_each_repo]

    config_file = YAML.load_file('config.yml')
    bitbucket = BitBucket.new basic_auth: config_file['username'] + ':' + config_file['password']

    Rails.logger.info 'Starting to fetch data from BitBucket for repos and commits using the username: ' + config_file['username']
    repos = bitbucket.repos.list

    repos.each do |repo|
      Rails.logger.info "Working on repo: #{repo['owner']}:#{repo['slug']}."

      begin
        repository = Repository.find_or_create_by!(name: repo['slug'].to_s, owner: repo['owner'].to_s)

        if repository.first_commit_sha
          Rails.logger.info "The first_commit_sha was set for #{repository.name}. Not querying further."
          next
        end

        grab_commits_from_bitbucket(commits_to_get, bitbucket, repository)

      rescue BitBucket::Error => error
        Rails.logger.error "An error occurred trying to query the changesets for #{repo['slug']}. Error was #{error}"
        next
      end
    end

    Rails.logger.info 'Fetching old commits finished'
  end

  def grab_commits_from_bitbucket(commits_to_get, bitbucket, repository)
    if commits_to_get <= 0
      Rails.logger.debug 'grab_commits_from_bitbucket was called with commits_to_get of 0 or less. Returning.'
      return
    end

    commits_to_get = commits_to_get < 50 ? commits_to_get : 50


    params = {'limit': commits_to_get}
    oldest_commit = find_oldest_commit_in_repo(repository)

    if oldest_commit
      params = {'limit': commits_to_get, 'start': oldest_commit.sha}
    end

    Rails.logger.debug "Fetching #{commits_to_get} commits from #{repository.owner}:#{repository.name}."
    begin
      changeset_list = bitbucket.repos.changesets.list(repository.owner, repository.name, params)
    rescue StandardError => error
      Rails.logger.warn "Query to get changesets from #{repository.name} resulted in an error: #{error}"
      return
    end

    available_commits_count = changeset_list['count']
    add_commits_to_db(changeset_list, bitbucket, repository)

    total_records_fetched = changeset_list['changesets'].count

    if (commits_to_get < 50) || (total_records_fetched < commits_to_get)
      Rails.logger.debug "The number of records received: #{total_records_fetched} for repository: #{repository.name} was less than the number asked for: #{commits_to_get}. There are no more commits to grab."
      earliest_commit_sha = Commit.where(repository_id: repository.id).order('utc_commit_time ASC').first.sha
      repository.update!(first_commit_sha: earliest_commit_sha)
      Rails.logger.info "The repository: #{repository.name} has had the first_commit_sha set to #{repository.first_commit_sha}. This will prevent historical queries on this repo from being run from now on."
      return
    end

    if total_records_fetched < commits_to_get && ((commits_to_get - total_records_fetched) < available_commits_count)
      grab_commits_from_bitbucket(commits_to_get - total_records_fetched, bitbucket, repository)
    end
  end

  def add_commits_to_db(changeset_list, bitbucket, repository)
    changeset_list['changesets'].each do |changeset|
      user = find_or_create_new_user changeset

      if /[\W]/.match user.account_name
        Rails.logger.debug "Username: #{user.account_name} was found to contain a non-word character. Can't fetch the avatar_uri. Setting it to the default."
        user.update(avatar_uri: 'https://bitbucket.org/account/unknown/avatar/48/?ts=0')
      end

      find_or_set_user_avatar_uri bitbucket, user

      commit = Commit.create(sha: changeset['raw_node'], message: changeset['message'],
                    utc_commit_time: changeset['utctimestamp'], branch_name: changeset['branch'],
                    user: user, repository: repository)

    end
  end

  def find_oldest_commit_in_repo(repo)
    commits_from_repo = Commit.where(repository_id: repo.id).order('utc_commit_time ASC')
    commits_from_repo.first
  end


  def find_or_create_new_user(changeset)
    account_name = changeset['author'].to_s
    user = User.find_or_create_by!(account_name: account_name) #Don't cache this because it will cause excess api calls for a new user's avatar_uri until it expires


    author_name = /\A(?:(?!\s<.*>\z).)+/.match(changeset['raw_author']).to_s
    email = /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i.match(changeset['raw_author']).to_s.downcase


    Rails.cache.fetch("users/#{account_name}/author_name/#{author_name}", expire_in: 30.seconds) do
      UserName.create(name: author_name, user: user)
    end

    Rails.cache.fetch("users/#{account_name}/email_address/#{email}", expire_in: 30.seconds) do
      EmailAddress.create(email: email, user: user)
    end

    user
  end

  def find_or_set_user_avatar_uri(bitbucket, user)
    if user.account_name && !user.avatar_uri
      Rails.logger.debug "Found a user: #{user.account_name} whose avatar_uri was empty or nil. Querying profile for avatar_uri."
      begin
        user_profile= bitbucket.users.account.profile(user.account_name)

      rescue BitBucket::Error::NotFound
        Rails.logger.warn "Query looking for #{user.account_name} resulted in a 404. Setting avatar to the default."
        user.update(avatar_uri: 'https://bitbucket.org/account/unknown/avatar/48/?ts=0')
        return
      end

      avatar_uri = user_profile['user']['avatar']
      avatar_uri.gsub!(/\/avatar\/32\//, '/avatar/48/')
      Rails.logger.debug "User #{user.account_name}'s avatar_uri is going to be updated with: #{avatar_uri}"
      user.update!(avatar_uri: avatar_uri)
    end
  end
end
