class ChangeCommitUrlToCommitUri < ActiveRecord::Migration[4.2]
  def change
    rename_column :commits, :url, :uri
  end
end
