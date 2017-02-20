class ChangeImageUriToAvatarUriForRepository < ActiveRecord::Migration
  def change
    rename_column :repositories, :image_uri, :avatar_uri
  end
end
