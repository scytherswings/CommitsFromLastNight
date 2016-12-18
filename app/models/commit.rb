class Commit < ActiveRecord::Base
  has_many :filtersets, through: :filtered_messages
  belongs_to :user
  belongs_to :repository
  validates_presence_of :sha, :message, :utc_commit_time, :user, :repository
  validates_uniqueness_of :sha
end
