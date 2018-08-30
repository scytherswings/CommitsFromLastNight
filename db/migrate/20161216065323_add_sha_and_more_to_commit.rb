class AddShaAndMoreToCommit < ActiveRecord::Migration[4.2]
  def change
    add_column :commits, :sha, :string
    add_column :commits, :url, :string
    add_column :commits, :timestamp, :datetime
  end
end
