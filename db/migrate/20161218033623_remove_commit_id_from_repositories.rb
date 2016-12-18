class RemoveCommitIdFromRepositories < ActiveRecord::Migration
  def change
    remove_index :repositories, :commit_id
    remove_column :repositories, :commit_id
  end
end