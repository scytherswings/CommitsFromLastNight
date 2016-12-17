class RemoveAuthorNameAndEmailFromUser < ActiveRecord::Migration
  def change
    remove_columns :users, :author_name, :email
  end
end
