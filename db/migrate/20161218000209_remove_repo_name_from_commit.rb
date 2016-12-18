class RemoveRepoNameFromCommit < ActiveRecord::Migration
  def change
    remove_column :commits, :repo_name
  end
end
