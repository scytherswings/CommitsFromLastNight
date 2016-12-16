class AddUserToCommit < ActiveRecord::Migration
  def change
    add_column :commits, :user_id, :integer
    add_index :commits, :user_id
  end
end
