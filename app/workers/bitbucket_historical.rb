require 'importers/bitbucket'
class BitbucketHistorical
  include Sidekiq::Worker
  sidekiq_options(queue: 'bitbucket', retry: false)

  def perform(commits_to_get)
    commits_to_get ||= 50
    Bitbucket.fetch_old_commits(commits_to_get)
  end
end
