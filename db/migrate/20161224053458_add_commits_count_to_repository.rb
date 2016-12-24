class AddCommitsCountToRepository < ActiveRecord::Migration
  def change
    add_column :repositories, :commits_count, :integer
  end
end
