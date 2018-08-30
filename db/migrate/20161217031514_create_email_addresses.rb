class CreateEmailAddresses < ActiveRecord::Migration[4.2]
  def change
    create_table :email_addresses do |t|
      t.string :email, null: false
      t.integer :user_id, null: false

      t.timestamps null: false
    end
  end
end
