class AddOwnerToRepository < ActiveRecord::Migration[4.2]
  def change
    add_column :repositories, :owner, :string
  end
end
