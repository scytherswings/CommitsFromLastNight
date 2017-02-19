class ChangeUriToResourceUri < ActiveRecord::Migration
  def change
    rename_column :commits, :uri, :resource_uri
    rename_column :repositories, :uri, :resource_uri
    rename_column :users, :uri, :resource_uri
  end
end
