# frozen_string_literal: true

require 'sidekiq'
require 'sidekiq-status'
require 'importers/bitbucket'
class BitbucketHistorical < KillableWorker
  include Sidekiq::Status::Worker
  sidekiq_options(queue: 'bitbucket', retry: false, backtrace: true)

  def perform(commits_to_get, logger = Sidekiq.logger)
    return if killed?

    commits_to_get ||= 50
    Importers::Bitbucket.new(logger).fetch_historical_commits(commits_to_get)
  end
end
