class Commit < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :sha, :message, :repo_name, :utc_commit_time, :user
  validates_uniqueness_of :sha
end
