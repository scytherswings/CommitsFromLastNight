class AddIndexToUtcCommitTimeInCommits < ActiveRecord::Migration
  def change
    add_index :commits, :utc_commit_time, order: {utc_commit_time: :desc}
  end
end
