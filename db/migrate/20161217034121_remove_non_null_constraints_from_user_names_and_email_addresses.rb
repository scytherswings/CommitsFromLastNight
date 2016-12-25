class RemoveNonNullConstraintsFromUserNamesAndEmailAddresses < ActiveRecord::Migration
  def change
    change_column_null :email_addresses, :user_id, true
  end
end
