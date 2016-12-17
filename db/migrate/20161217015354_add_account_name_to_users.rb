class AddAccountNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :account_name, :string
  end
end
