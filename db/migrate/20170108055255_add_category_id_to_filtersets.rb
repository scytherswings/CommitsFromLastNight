class AddCategoryIdToFiltersets < ActiveRecord::Migration
  def change
    add_column :filtersets, :category_id, :integer
    add_index :filtersets, :category_id
    add_index :filtersets, :name
  end
end
