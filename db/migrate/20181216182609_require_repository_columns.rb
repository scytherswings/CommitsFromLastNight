class RequireRepositoryColumns < ActiveRecord::Migration[5.2]
  def change
    change_column_null :repositories, :name, false
  end
end
