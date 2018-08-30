class AddUniqueConstraingToShaInCommits < ActiveRecord::Migration[4.2]
  def change
    add_index :commits, :sha, unique: true
  end
end
