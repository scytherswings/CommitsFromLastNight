class RemoveRepoNameFromCommit < ActiveRecord::Migration[4.2]
  def change
    remove_column :commits, :repo_name
  end
end
