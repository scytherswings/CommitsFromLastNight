# frozen_string_literal: true

class AddIndexesToForeignKeysForEmailsAndUserNames < ActiveRecord::Migration[4.2]
  def change
    add_index :email_addresses, :user_id
  end
end
