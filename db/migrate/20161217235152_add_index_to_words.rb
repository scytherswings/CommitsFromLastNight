class AddIndexToWords < ActiveRecord::Migration[4.2]
  def change
    add_index :words, :word, unique: true
  end
end
