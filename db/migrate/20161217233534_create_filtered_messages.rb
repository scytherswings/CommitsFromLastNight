class CreateFilteredMessages < ActiveRecord::Migration
  def change
    create_table :filtered_messages do |t|
      t.integer :filterset_id
      t.integer :commit_id

      t.timestamps null: false
    end
    add_index :filtered_messages, :filterset_id
    add_index :filtered_messages, :commit_id
  end
end
