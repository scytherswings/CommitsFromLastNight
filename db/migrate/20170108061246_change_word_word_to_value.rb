class ChangeWordWordToValue < ActiveRecord::Migration
  def change
    rename_column :words, :word, :value
  end
end
