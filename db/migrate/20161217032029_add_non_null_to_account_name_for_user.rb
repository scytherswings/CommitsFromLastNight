class AddNonNullToAccountNameForUser < ActiveRecord::Migration
  def change
    change_column_null :users, :account_name, false
  end
end
