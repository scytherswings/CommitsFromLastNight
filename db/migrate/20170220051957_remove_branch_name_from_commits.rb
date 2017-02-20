class RemoveBranchNameFromCommits < ActiveRecord::Migration
  def change
  remove_column :commits, :branch_name
  end
end
