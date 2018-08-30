class AddUriToRepository < ActiveRecord::Migration[4.2]
  def change
    add_column :repositories, :uri, :string
  end
end
