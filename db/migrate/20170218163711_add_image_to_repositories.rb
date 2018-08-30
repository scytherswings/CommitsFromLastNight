class AddImageToRepositories < ActiveRecord::Migration[4.2]
  def change
    add_column :repositories, :image, :string
  end
end
