class AddIndexesToForeignKeysForEmailsAndUserNames < ActiveRecord::Migration
  def change
    add_index :user_names, :user_id
    add_index :email_addresses, :user_id
  end
end
