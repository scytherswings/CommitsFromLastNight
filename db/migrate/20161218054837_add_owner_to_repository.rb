class AddOwnerToRepository < ActiveRecord::Migration
  def change
    add_column :repositories, :owner, :string
  end
end
