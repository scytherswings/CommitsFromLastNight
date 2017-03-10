require 'coveralls'
Coveralls.wear!('rails')
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'webmock'
require 'webmock/minitest'
require 'minitest/reporters'
require 'vcr'
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  VCR.configure do |config|
    config.cassette_library_dir = 'test/data/vcr_cassettes'
    config.hook_into :webmock
    config.default_cassette_options = {
        :record => :new_episodes
    }
    config.filter_sensitive_data('<AUTHORIZATION>', :authorization) { ENV['BB_AUTH_TOKEN']}
  end

  # VCR.turn_off!(ignore_cassettes: true)
  # WebMock.disable!


  def setup
    file = File.open('test/fixtures/JSON/bitbucket_commits_for_repo.json')
    @changesets = JSON.parse(file.readlines.join(''))
  end
  # Add more helper methods to be used by all tests here...
end
