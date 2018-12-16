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

class Commit < ActiveRecord::Base
  include ArelHelpers::ArelTable
  has_many :filtered_messages, dependent: :destroy
  has_many :filtersets, through: :filtered_messages
  has_many :filter_words, through: :filtered_messages
  has_many :categories, through: :filtersets
  belongs_to :user, counter_cache: true
  belongs_to :repository, counter_cache: true

  validates_presence_of :sha, :message, :utc_commit_time, :user, :repository
  validates_uniqueness_of :sha

  self.per_page = 30
end
