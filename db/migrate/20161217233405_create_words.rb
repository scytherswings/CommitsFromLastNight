# frozen_string_literal: true

class CreateWords < ActiveRecord::Migration[4.2]
  def change
    create_table :words do |t|
      t.string :word, null: false

      t.timestamps null: false
    end
  end
end
