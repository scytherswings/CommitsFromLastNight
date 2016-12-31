class AddIndexToWords < ActiveRecord::Migration
  def change
    add_index :words, :word, unique: true
  end
end
