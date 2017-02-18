require 'importers/bitbucket'

desc 'Fetches all repositories'
task bitbucket_fetch_all_repositories: :environment do
  Importers::Bitbucket.fetch_all_repositories
end

desc "Fetches 'n' historical commits per repository."
task :bitbucket_fetch_historical_commits, [:commits_to_grab_from_each_repo] => :environment do |_, args|
  commits_to_get = Integer(args[:commits_to_grab_from_each_repo])
  BitbucketHistorical.perform_async(commits_to_get)
end