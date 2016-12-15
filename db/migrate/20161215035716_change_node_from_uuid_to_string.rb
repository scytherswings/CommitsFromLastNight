class ChangeNodeFromUuidToString < ActiveRecord::Migration
  def change
    rename_column :commits, :node, :raw_node
    change_column :commits, :raw_node, :string
  end
end
