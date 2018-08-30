class AddCommitsCountToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :commits_count, :integer
  end
end
