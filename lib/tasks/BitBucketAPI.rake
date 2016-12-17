namespace :BitBucketAPI do

  desc 'Fetches the lastest commits based on the newest timestamp found in the database.'
  task fetch_latest_commits: :environment do
    # Rails.logger = Logger.new(STDOUT)
    Rails.logger.debug 'Starting to fetch latest commits'

    config_file = YAML.load_file('config.yml')
    bitbucket = BitBucket.new basic_auth: config_file['username'] + ':' + config_file['password']
    repos = bitbucket.repos.list

    Rails.logger.debug repos.to_json

    repos.each do |repo|
      Rails.logger.debug 'Working on repo: ' + repo['slug']

      changesets = bitbucket.repos.changesets.all repo['owner'], repo['slug']
      Rails.logger.debug changesets.to_json

      changesets['changesets'].each do |changeset|
        user = find_or_create_new_users changeset

        Commit.create(message: changeset['message'], utc_commit_time: changeset['utctimestamp'],
                      repo_name: repo['slug'], branch_name: changeset['branch'], sha: changeset['raw_node'], user: user)
      end
    end

    Rails.logger.debug 'Fetching latest commits finished'
  end

  desc 'Fetches up to [n] old commits'
  task :fetch_old_commits, [:commits_to_grab] => :environment do |_, args|
    puts "I grabbed old stuff:  #{args[:commits_to_grab]}"
  end

  def fetch_from_bitbucket

  end

  def find_or_create_new_users changeset
    author_name = /\A(?:(?!\s<.*>\z).)+/.match(changeset['raw_author']).to_s
    email = /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i.match(changeset['raw_author']).to_s
    account_name = changeset['author']

    user = User.find_or_create_by!(account_name: account_name)
    UserName.find_or_create_by!(name: author_name, user: user)
    EmailAddress.find_or_create_by!(email: email, user: user)

    user
  end
end
