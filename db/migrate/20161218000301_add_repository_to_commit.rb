# frozen_string_literal: true

class AddRepositoryToCommit < ActiveRecord::Migration[4.2]
  def change
    add_column :commits, :repository_id, :integer
    add_index :commits, :repository_id
  end
end
