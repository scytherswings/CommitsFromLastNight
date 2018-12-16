# frozen_string_literal: true

class AddAccountNameToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :account_name, :string
  end
end
