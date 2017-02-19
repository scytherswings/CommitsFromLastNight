class ChangeRepositoryImageToImageUri < ActiveRecord::Migration
  def change
    rename_column :repositories, :image, :image_uri
  end
end
