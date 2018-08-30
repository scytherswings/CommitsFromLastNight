class AddNonNullToAccountNameForUser < ActiveRecord::Migration[4.2]
  def change
    change_column_null :users, :account_name, false
  end
end
