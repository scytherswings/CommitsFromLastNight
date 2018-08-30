class AddNonNullConstraintToRepositoryLanguages < ActiveRecord::Migration[4.2]
  def change
    change_column_null :repository_languages, :repository_id, false
    change_column_null :repository_languages, :word_id, false
  end
end
