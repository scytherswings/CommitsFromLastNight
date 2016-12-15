class AddNodeToCommit < ActiveRecord::Migration
  def change
    add_column :commits, :node, :uuid
  end
end
