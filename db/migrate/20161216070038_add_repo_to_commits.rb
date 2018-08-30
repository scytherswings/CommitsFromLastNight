class AddRepoToCommits < ActiveRecord::Migration[4.2]
  def change
    add_column :commits, :repo_name, :string
  end
end
