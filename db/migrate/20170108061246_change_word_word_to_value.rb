# frozen_string_literal: true

class ChangeWordWordToValue < ActiveRecord::Migration[4.2]
  def change
    rename_column :words, :word, :value
  end
end
