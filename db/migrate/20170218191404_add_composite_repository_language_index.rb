class AddCompositeRepositoryLanguageIndex < ActiveRecord::Migration
  def change
    add_index :repository_languages, [:repository_id, :word_id], unique: true
  end
end
