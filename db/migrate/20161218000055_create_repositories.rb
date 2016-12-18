class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.string :name
      t.integer :commit_id

      t.timestamps null: false
    end
    add_index :repositories, :commit_id
  end
end
