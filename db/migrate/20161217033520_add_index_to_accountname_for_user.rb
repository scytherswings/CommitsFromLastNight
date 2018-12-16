# frozen_string_literal: true

class AddIndexToAccountnameForUser < ActiveRecord::Migration[4.2]
  def change
    add_index :users, :account_name
  end
end
