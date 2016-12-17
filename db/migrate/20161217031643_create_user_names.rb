class CreateUserNames < ActiveRecord::Migration
  def change
    create_table :user_names do |t|
      t.string :name, null: false
      t.integer :user_id, null: false

      t.timestamps null: false
    end
  end
end
