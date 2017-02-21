require 'importers/bitbucket'
class BitbucketLatest
  include Sidekiq::Worker
  sidekiq_options(queue: 'bitbucket', retry: false, backtrace: true)

  def perform
    Importers::Bitbucket.fetch_latest_commits
  end
end
