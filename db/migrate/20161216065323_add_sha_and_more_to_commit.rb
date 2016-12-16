class AddShaAndMoreToCommit < ActiveRecord::Migration
  def change
    add_column :commits, :sha, :string
    add_column :commits, :url, :string
    add_column :commits, :timestamp, :datetime
  end
end
