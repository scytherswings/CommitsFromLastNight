class Commit < ActiveRecord::Base
  has_many :filtersets, through: :filtered_messages
  belongs_to :user
  belongs_to :repository
  validates_presence_of :sha, :message, :repo_name, :utc_commit_time, :user
  validates_uniqueness_of :sha
end
