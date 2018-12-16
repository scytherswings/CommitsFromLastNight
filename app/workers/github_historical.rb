# frozen_string_literal: true

class GithubHistorical
  include Sidekiq::Worker

  def perform(*args)
    # Do something
  end
end
