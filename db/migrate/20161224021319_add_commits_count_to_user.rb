class AddCommitsCountToUser < ActiveRecord::Migration
  def change
    add_column :users, :commits_count, :integer
  end
end
