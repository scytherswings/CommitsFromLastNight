# frozen_string_literal: true

class ReprocessCommits
  include Sidekiq::Worker
  sidekiq_options(queue: 'default', retry: false, backtrace: true)

  def perform
    Commit.select(:id).each_instance { |commit_id| ReexecuteFilters.perform_async((commit_id['id'])) }
  end
end
