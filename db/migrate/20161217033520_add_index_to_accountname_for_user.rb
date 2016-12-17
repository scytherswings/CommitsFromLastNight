class AddIndexToAccountnameForUser < ActiveRecord::Migration
  def change
    add_index :users, :account_name
  end
end
