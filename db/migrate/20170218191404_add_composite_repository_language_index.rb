class AddCompositeRepositoryLanguageIndex < ActiveRecord::Migration[4.2]
  def change
    add_index :repository_languages, [:repository_id, :word_id], unique: true
  end
end
