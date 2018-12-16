# frozen_string_literal: true

class AddDescriptionToRepositories < ActiveRecord::Migration[4.2]
  def change
    add_column :repositories, :description, :text
  end
end
