class ChangeCommitUrlToCommitUri < ActiveRecord::Migration
  def change
    rename_column :commits, :url, :uri
  end
end
