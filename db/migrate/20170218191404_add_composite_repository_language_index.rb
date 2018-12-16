# frozen_string_literal: true

class AddCompositeRepositoryLanguageIndex < ActiveRecord::Migration[4.2]
  def change
    add_index :repository_languages, %i[repository_id word_id], unique: true
  end
end
