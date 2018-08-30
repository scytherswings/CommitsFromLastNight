class RenameBranchToBranchName < ActiveRecord::Migration[4.2]
  def change
    rename_column :commits, :branch, :branch_name
  end
end
