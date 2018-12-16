# == Schema Information
#
# Table name: commits
#
#  id              :integer          not null, primary key
#  message         :text
#  resource_uri    :string
#  sha             :string
#  utc_commit_time :datetime
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  repository_id   :integer
#  user_id         :integer          not null
#
# Indexes
#
#  index_commits_on_repository_id_and_sha  (repository_id,sha) UNIQUE
#  index_commits_on_user_id                (user_id)
#  index_commits_on_utc_commit_time        (utc_commit_time)
#

require 'test_helper'

class CommitTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
