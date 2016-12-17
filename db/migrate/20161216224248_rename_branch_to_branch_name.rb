class RenameBranchToBranchName < ActiveRecord::Migration
  def change
    rename_column :commits, :branch, :branch_name
  end
end
