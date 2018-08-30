class RemoveAuthorNameAndEmailFromUser < ActiveRecord::Migration[4.2]
  def change
    remove_columns :users, :author_name, :email
  end
end
