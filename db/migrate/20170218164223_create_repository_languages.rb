class CreateRepositoryLanguages < ActiveRecord::Migration
  def change
    create_table :repository_languages do |t|
      t.integer :repository_id
      t.integer :word_id

      t.timestamps null: false
    end
    add_index :repository_languages, :repository_id
    add_index :repository_languages, :word_id
  end
end