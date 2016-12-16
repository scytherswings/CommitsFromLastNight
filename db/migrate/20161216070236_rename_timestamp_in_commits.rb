class RenameTimestampInCommits < ActiveRecord::Migration
  def change
    rename_column :commits, :timestamp, :utc_commit_time
  end
end
