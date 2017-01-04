class CreateFilterCategories < ActiveRecord::Migration
  def change
    create_table :filter_categories do |t|
      t.integer :category_id, null: false
      t.integer :filterset_id, null: false

      t.timestamps null: false
    end
    add_index :filter_categories, :category_id
    add_index :filter_categories, :filterset_id
  end
end
