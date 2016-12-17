class AddAvatarUriToUsers < ActiveRecord::Migration
  def change
    add_column :users, :avatar_uri, :string
  end
end
