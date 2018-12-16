# frozen_string_literal: true

class ChangeNodeFromUuidToString < ActiveRecord::Migration[4.2]
  def change
    rename_column :commits, :node, :raw_node
    change_column :commits, :raw_node, :string
  end
end
