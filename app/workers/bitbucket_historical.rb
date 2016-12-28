require 'importers/bitbucket'
class BitbucketHistorical
  include Sidekiq::Worker

  def perform(*args)
    commits_to_get ||= 100
    Bitbucket.fetch_old_commits(commits_to_get)
  end
end
