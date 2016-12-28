require 'importers/bitbucket'
class BitbucketHistorical
  include Sidekiq::Worker
  sidekiq_options(queue: 'bitbucket', retry: false)

  def perform(*args)
    commits_to_get ||= args[0]['commits_to_get']
    Bitbucket.fetch_old_commits(commits_to_get)
  end
end
