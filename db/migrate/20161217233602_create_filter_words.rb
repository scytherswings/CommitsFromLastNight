class CreateFilterWords < ActiveRecord::Migration
  def change
    create_table :filter_words do |t|
      t.integer :word_id
      t.integer :filterset_id

      t.timestamps null: false
    end
    add_index :filter_words, :word_id
    add_index :filter_words, :filterset_id
  end
end
