class RemoveUsernameFromCommits < ActiveRecord::Migration[4.2]
  def change
    remove_column :commits, :username
    remove_column :commits, :user_avatar
    remove_column :commits, :commit_time
    remove_column :commits, :repository
    remove_index :commits, :raw_node
    remove_column :commits, :raw_node
  end
end
