class Commit < ActiveRecord::Base
  has_many :filtered_messages
  has_many :filtersets, through: :filtered_messages
  belongs_to :user, counter_cache: true
  belongs_to :repository, counter_cache: true
  belongs_to :filterset, counter_cache: true
  belongs_to :category, counter_cache: true

  validates_presence_of :sha, :message, :utc_commit_time, :user, :repository
  validates_uniqueness_of :sha

  self.per_page = 30
end
