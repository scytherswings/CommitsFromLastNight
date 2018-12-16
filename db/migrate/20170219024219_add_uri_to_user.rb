# frozen_string_literal: true

class AddUriToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :uri, :string
  end
end
