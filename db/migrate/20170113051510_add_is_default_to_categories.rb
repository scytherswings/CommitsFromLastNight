class AddIsDefaultToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :default, :boolean, null: false
  end
end
