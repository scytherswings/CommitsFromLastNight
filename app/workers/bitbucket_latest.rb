# frozen_string_literal: true

require 'importers/bitbucket'
class BitbucketLatest
  include Sidekiq::Worker
  sidekiq_options(queue: 'bitbucket', retry: false, backtrace: true)

  def perform(logger = Sidekiq.logger)
    Importers::Bitbucket.new(logger).fetch_latest_commits
  end
end
