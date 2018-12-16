class ForceEmailAddressesToBeUnique < ActiveRecord::Migration[5.2]
  def change
    add_index :email_addresses, :email, unique: true
  end
end
