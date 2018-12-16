# frozen_string_literal: true

class ChangeRepositoryImageToImageUri < ActiveRecord::Migration[4.2]
  def change
    rename_column :repositories, :image, :image_uri
  end
end
