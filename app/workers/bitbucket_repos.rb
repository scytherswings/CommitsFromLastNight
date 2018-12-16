# frozen_string_literal: true

require 'importers/bitbucket'
class BitbucketRepos
  include Sidekiq::Worker
  sidekiq_options(queue: 'bitbucket', retry: false, backtrace: true)

  def perform(logger = Sidekiq.logger)
    Importers::Bitbucket.new(logger).fetch_all_repositories
  end
end
