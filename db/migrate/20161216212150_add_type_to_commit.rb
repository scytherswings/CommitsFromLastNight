class AddTypeToCommit < ActiveRecord::Migration
  def change
    add_column :commits, :type, :string
  end
end
