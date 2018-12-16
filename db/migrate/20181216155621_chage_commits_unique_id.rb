class ChageCommitsUniqueId < ActiveRecord::Migration[5.2]
  def change
    remove_index :commits, :sha
    remove_index :commits, :repository_id
    add_index :commits, [:repository_id, :sha], unique: true
  end
end
