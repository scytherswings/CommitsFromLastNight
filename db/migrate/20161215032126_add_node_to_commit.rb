# frozen_string_literal: true

class AddNodeToCommit < ActiveRecord::Migration[4.2]
  def change
    add_column :commits, :node, :uuid
  end
end
