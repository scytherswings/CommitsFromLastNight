class CreateWhiteListWords < ActiveRecord::Migration
  def change
    create_table :white_list_words do |t|
      t.integer :word_id
      t.integer :filterset_id
      t.string :word_id
      t.string :filterset_id

      t.timestamps null: false
    end
    add_index :white_list_words, :word_id
    add_index :white_list_words, :filterset_id
  end
end
