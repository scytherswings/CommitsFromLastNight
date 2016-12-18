class AddRepositoryToCommit < ActiveRecord::Migration
  def change
    add_column :commits, :repository_id, :integer
    add_index :commits, :repository_id
  end
end
