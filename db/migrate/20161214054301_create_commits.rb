class CreateCommits < ActiveRecord::Migration[4.2]
  def change
    create_table :commits do |t|
      t.string :username
      t.string :user_avatar
      t.string :message
      t.datetime :commit_time
      t.string :repository
      t.string :branch

      t.timestamps null: false
    end
  end
end
