class AddAvatarUriToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :avatar_uri, :string
  end
end
