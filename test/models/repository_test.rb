# frozen_string_literal: true

# == Schema Information
#
# Table name: repositories
#
#  id               :integer          not null, primary key
#  avatar_uri       :string
#  commits_count    :integer
#  description      :text
#  first_commit_sha :string
#  name             :string           not null
#  owner            :string
#  resource_uri     :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_repositories_on_name  (name) UNIQUE
#

require 'test_helper'

class RepositoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
