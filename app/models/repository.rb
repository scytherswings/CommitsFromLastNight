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

class Repository < ActiveRecord::Base
  include ArelHelpers::ArelTable
  has_many :commits, dependent: :destroy
  has_many :repository_languages, dependent: :destroy
  has_many :users, through: :commits

  validates_uniqueness_of :name
end
