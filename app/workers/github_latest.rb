# frozen_string_literal: true

class GithubLatest
  include Sidekiq::Worker

  def perform(*args)
    # Do something
  end
end
