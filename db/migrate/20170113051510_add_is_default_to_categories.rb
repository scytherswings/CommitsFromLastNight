class AddIsDefaultToCategories < ActiveRecord::Migration[4.2]
  def change
    add_column :categories, :default, :boolean, null: false
  end
end
