require 'importers/bitbucket'
class BitbucketHistorical
  include Sidekiq::Worker
  sidekiq_options(queue: 'bitbucket', retry: false, backtrace: true)

  def perform(commits_to_get, logger=Sidekiq.logger)
    commits_to_get ||= 50
    Importers::Bitbucket.new(logger).fetch_old_commits(commits_to_get)
  end
end
