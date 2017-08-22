# == Schema Information
#
# Table name: commits
#
#  id              :integer          not null, primary key
#  message         :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_id         :integer          not null
#  sha             :string
#  resource_uri    :string
#  utc_commit_time :datetime
#  repository_id   :integer
#

require 'test_helper'

class CommitTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
