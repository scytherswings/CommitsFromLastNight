class RemoveBranchNameFromCommits < ActiveRecord::Migration[4.2]
  def change
  remove_column :commits, :branch_name
  end
end
