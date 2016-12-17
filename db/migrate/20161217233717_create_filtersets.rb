class CreateFiltersets < ActiveRecord::Migration
  def change
    create_table :filtersets do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
