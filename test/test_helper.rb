# frozen_string_literal: true

ENV['RAILS_ENV'] ||= 'test'

require 'simplecov'
require 'minitest/reporters'
require 'minitest/ci'
require 'vcr'

Minitest::Ci.report_dir = Rails.root.join('tmp', 'test-results')
SimpleCov.coverage_dir(Rails.root.join('tmp', 'coverage', 'backend'))

Minitest::Reporters.use!
SimpleCov.start 'rails'

require File.expand_path('../config/environment', __dir__)
require 'rails/test_help'
require 'webmock'
require 'webmock/minitest'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  VCR.configure do |config|
    config.cassette_library_dir = 'test/data/vcr_cassettes'
    config.hook_into :webmock
    config.default_cassette_options = {
      record: :new_episodes
    }
    config.filter_sensitive_data('<AUTHORIZATION>', :authorization) { ENV['BB_AUTH_TOKEN'] }
  end

  # VCR.turn_off!(ignore_cassettes: true)
  # WebMock.disable!

  def setup
    file = File.open('test/fixtures/JSON/bitbucket_commits_for_repo.json')
    @changesets = JSON.parse(file.readlines.join(''))
  end
  # Add more helper methods to be used by all tests here...
end
