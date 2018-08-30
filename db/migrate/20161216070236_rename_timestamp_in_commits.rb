class RenameTimestampInCommits < ActiveRecord::Migration[4.2]
  def change
    rename_column :commits, :timestamp, :utc_commit_time
  end
end
