# frozen_string_literal: true

class CreateFiltersets < ActiveRecord::Migration[4.2]
  def change
    create_table :filtersets do |t|
      t.string :name
      t.integer :commits_count
      t.timestamps null: false
    end
  end
end
