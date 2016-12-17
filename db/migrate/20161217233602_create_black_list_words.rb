class CreateBlackListWords < ActiveRecord::Migration
  def change
    create_table :black_list_words do |t|
      t.integer :word_id
      t.integer :filterset_id
      t.string :word_id
      t.string :filterset_id

      t.timestamps null: false
    end
    add_index :black_list_words, :word_id
    add_index :black_list_words, :filterset_id
  end
end
