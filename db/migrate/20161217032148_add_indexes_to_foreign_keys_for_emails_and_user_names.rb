class AddIndexesToForeignKeysForEmailsAndUserNames < ActiveRecord::Migration
  def change
    add_index :email_addresses, :user_id
  end
end
