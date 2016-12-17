class RemoveNonNullConstraintsFromUserNamesAndEmailAddresses < ActiveRecord::Migration
  def change
    change_column_null :email_addresses, :user_id, true
    change_column_null :user_names, :user_id, true
  end
end
