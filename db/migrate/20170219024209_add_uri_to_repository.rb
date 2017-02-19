class AddUriToRepository < ActiveRecord::Migration
  def change
    add_column :repositories, :uri, :string
  end
end
