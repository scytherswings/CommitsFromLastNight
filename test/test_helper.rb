require 'coveralls'
Coveralls.wear!('rails')
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'
require 'json'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def setup
    file = File.open('test/fixtures/JSON/bitbucket_commits_for_repo.json')
    @changesets = JSON.parse(file.readlines.join(''))
  end
  # Add more helper methods to be used by all tests here...
end
