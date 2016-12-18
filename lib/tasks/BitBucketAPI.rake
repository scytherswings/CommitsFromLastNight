namespace :BitBucketAPI do

  desc 'Fetches the lastest commits based on the newest timestamp found in the database.'
  task fetch_latest_commits: :environment do
    # Rails.logger = Logger.new(STDOUT)

    config_file = YAML.load_file('config.yml')
    bitbucket = BitBucket.new basic_auth: config_file['username'] + ':' + config_file['password']

    Rails.logger.debug 'Starting to fetch data from BitBucket for repos and commits using the username: ' + config_file['username']
    repos = bitbucket.repos.list

    repos.each do |repo|
      Rails.logger.debug 'Working on repo: ' + repo['slug']

      begin
        repository = Repository.find_or_create_by!(name: repo['slug'])
        grab_commits_from_bitbucket(5, bitbucket, repository, repo['owner'])

        changesets = bitbucket.repos.changesets.all repo['owner'], repo['slug']
      rescue BitBucket::Error => error
        Rails.logger.error "An error occurred trying to query the changesets for #{repo['slug']}. Error was #{error}"
        next
      end

      changesets['changesets'].each do |changeset|
        user = find_or_create_new_user changeset

        find_or_set_user_avatar_uri bitbucket, user
        repository = Repository.find_or_create_by!(name: repo['slug'])

        Commit.find_or_create_by!(sha: changeset['raw_node'], message: changeset['message'],
                                  utc_commit_time: changeset['utctimestamp'], branch_name: changeset['branch'],
                                  user: user, repository: repository)
      end
    end

    Rails.logger.debug 'Fetching latest commits finished'
  end

  desc 'Fetches up to [n] old commits'
  task :fetch_old_commits, [:commits_to_grab] => :environment do |_, args|
    puts "I grabbed old stuff:  #{args[:commits_to_grab]}"
  end

  def grab_commits_from_bitbucket(commits_to_get, bitbucket, repository, repo_owner)
    commits_to_get = commits_to_get < 50 ? commits_to_get : 50

    oldest_commit = find_oldest_commit_in_repo repository
    changelist = bitbucket.repos.changesets.list(repo_owner, repository.name, {'limit': commits_to_get, 'start': oldest_commit.sha})
    if changelist['count']

    end
  end

  def find_oldest_commit_in_repo(repo)
    commits_from_repo = Commit.where(repository_id: repo.id).order('utc_commit_time ASC')
    commits_from_repo.first
  end


  def find_or_create_new_user(changeset)
    account_name = changeset['author']
    user = Rails.cache.fetch("users/#{account_name}", expire_in: 30.seconds) do
      User.find_or_create_by!(account_name: account_name)
    end

    author_name = /\A(?:(?!\s<.*>\z).)+/.match(changeset['raw_author']).to_s
    email = /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i.match(changeset['raw_author']).to_s.downcase

    if /[\W_]/.match account_name
      Rails.logger.fatal "Username: #{account_name} was found to contain a non-word character or number! WTF. #{changeset.to_json}"
      exit! 1
    end

    Rails.cache.fetch("users/#{account_name}/author_name/#{author_name}", expire_in: 30.seconds) do
      User.find_or_create_by!(account_name: account_name)
    end

    Rails.cache.fetch("users/#{account_name}/email_address/#{author_name}", expire_in: 30.seconds) do
      EmailAddress.find_or_create_by!(email: email, user: user)
    end

    user
  end

  def find_or_set_user_avatar_uri(bitbucket, user)
    if user.account_name && !user.avatar_uri
      Rails.logger.debug "Found a user: #{user.account_name} whose avatar_uri was nil or empty. Querying profile for avatar_uri."
      user_profile = bitbucket.users.account.profile(user.account_name)
      Rails.logger.debug 'User profile: ' + user_profile.to_json
      user.update(avatar_uri: user_profile['user']['avatar'])
    end
  end
end
