class CreateRepositories < ActiveRecord::Migration[4.2]
  def change
    create_table :repositories do |t|
      t.string :name
      t.integer :commit_id

      t.timestamps null: false
    end
    add_index :repositories, :commit_id
    add_index :repositories, :name, unique: :true
  end
end
