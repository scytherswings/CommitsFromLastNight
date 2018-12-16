# frozen_string_literal: true

require 'test_helper'

class BitbucketHistoricalTest < ActiveSupport::TestCase
  test 'historical commits can be imported' do
    Commit.destroy_all # Delete the one added through a fixture
    VCR.use_cassette('bitbucket/historical_import') do
      assert_difference('Commit.count', +5) do
        BitbucketHistorical.new.perform(5, Rails.logger)
      end
    end
  end

  test 'specified number of historical commits can be imported' do
    VCR.use_cassette('bitbucket/historical_import_specified') do
      assert_difference('Commit.count', +1) do
        BitbucketHistorical.new.perform(5, Rails.logger)
      end
    end
  end
end
