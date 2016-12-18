class AddIndexToUtcCommitTimeInCommits < ActiveRecord::Migration
  def change
    add_index :commits, :utc_commit_time
  end
end
