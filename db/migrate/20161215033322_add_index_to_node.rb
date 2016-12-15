class AddIndexToNode < ActiveRecord::Migration
  def change
    add_index :commits, :node
  end
end
