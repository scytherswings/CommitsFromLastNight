# frozen_string_literal: true

class AddUserToCommit < ActiveRecord::Migration[4.2]
  def change
    add_column :commits, :user_id, :integer
    add_index :commits, :user_id
  end
end
