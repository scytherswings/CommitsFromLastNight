require 'importers/bitbucket'

desc 'Fetches all repositories'
task bitbucket_fetch_all_repositories: :environment do
  BitbucketRepos.perform_async
end

desc "Fetches 'n' historical commits per repository."
task :bitbucket_fetch_historical_commits, [:commits_to_grab_from_each_repo] => :environment do |_, args|
  commits_to_get = Integer(args[:commits_to_grab_from_each_repo])
  BitbucketHistorical.perform_async(commits_to_get)
end

desc 'Re-fetches all user avatars'
task bitbucket_fetch_all_user_avatars: :environment do
  bitbucket = Importers::Bitbucket.create_bitbucket_client
  User.select(:id, :avatar_uri, :account_name).each_instance do |user|
    user.update!(avatar_uri: nil)
    if user.account_name && !user.avatar_uri
      Sidekiq.logger.debug { "Found a user: #{user.account_name} whose avatar_uri was empty or nil. Querying profile for avatar_uri." }

      begin
        user_to_query = URI.encode(user.account_name)
        user_profile= bitbucket.users.account.profile(user_to_query)

      rescue BitBucket::Error::NotFound
        Sidekiq.logger.warn { "Query looking for #{user_to_query} resulted in a 404. Setting avatar to the default." }
        user.update(avatar_uri: 'https://bitbucket.org/account/unknown/avatar/96/?ts=0')
        next
      end

      avatar_uri = user_profile['user']['avatar']
      avatar_uri.gsub!(/\/avatar\/\d+\//, '/avatar/96/')
      Sidekiq.logger.debug { "User #{user.account_name}'s avatar_uri is going to be updated with: #{avatar_uri}" }
      user.update!(avatar_uri: avatar_uri)
    end
  end
end