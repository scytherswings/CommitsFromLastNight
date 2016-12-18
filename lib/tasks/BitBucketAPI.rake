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
        grab_commits_from_bitbucket(5, Repository.find_or_create_by!(name: repo['slug']))
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

  def grab_commits_from_bitbucket(commits_to_get, repo)
    oldest_commit = find_oldest_commit_in_repo repo


  end

  def find_oldest_commit_in_repo(repo)
    commits_from_repo = Commit.where(repository_id:repo.id).order('utc_commit_time ASC')
    commits_from_repo.first
  end


  def find_or_create_new_user(changeset)
    author_name = /\A(?:(?!\s<.*>\z).)+/.match(changeset['raw_author']).to_s
    email = /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i.match(changeset['raw_author']).to_s.downcase
    account_name = changeset['author']

    if /[\W_]/.match account_name
      Rails.logger.error "Username: #{account_name} was found to contain a non-word character or number! WTF. #{changeset.to_json}"
    end
    user = User.find_or_create_by!(account_name: account_name)
    UserName.find_or_create_by!(name: author_name, user: user)
    EmailAddress.find_or_create_by!(email: email, user: user)

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
