# frozen_string_literal: true

class RemoveNonNullConstraintsFromUserNamesAndEmailAddresses < ActiveRecord::Migration[4.2]
  def change
    change_column_null :email_addresses, :user_id, true
  end
end
