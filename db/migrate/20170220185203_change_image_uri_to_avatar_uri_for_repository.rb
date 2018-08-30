class ChangeImageUriToAvatarUriForRepository < ActiveRecord::Migration[4.2]
  def change
    rename_column :repositories, :image_uri, :avatar_uri
  end
end
