require 'test_helper'
class BitbucketLatestTest < ActiveSupport::TestCase
  test 'latest commits can be imported' do
    VCR.use_cassette('bitbucket/latest_import') do
      assert_difference('Commit.count', +4) do
        BitbucketLatest.new.perform(Rails.logger)
      end
    end
  end
end
