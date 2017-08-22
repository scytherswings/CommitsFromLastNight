# == Schema Information
#
# Table name: repositories
#
#  id               :integer          not null, primary key
#  name             :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  owner            :string
#  first_commit_sha :string
#  commits_count    :integer
#  description      :text
#  avatar_uri       :string
#  resource_uri     :string
#

require 'test_helper'

class RepositoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
