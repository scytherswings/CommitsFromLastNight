class AddRepoToCommits < ActiveRecord::Migration
  def change
    add_column :commits, :repo_name, :string
  end
end
