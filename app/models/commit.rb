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
