# frozen_string_literal: true

# == Schema Information
#
# Table name: repository_languages
#
#  id            :integer          not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  repository_id :integer          not null
#  word_id       :integer          not null
#
# Indexes
#
#  index_repository_languages_on_repository_id              (repository_id)
#  index_repository_languages_on_repository_id_and_word_id  (repository_id,word_id) UNIQUE
#  index_repository_languages_on_word_id                    (word_id)
#

class RepositoryLanguage < ApplicationRecord
  include ArelHelpers::ArelTable
  belongs_to :repository
  belongs_to :word
  validates :word, :repository, presence: true
end
