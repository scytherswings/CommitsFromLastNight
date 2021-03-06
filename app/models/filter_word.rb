# frozen_string_literal: true

# == Schema Information
#
# Table name: filter_words
#
#  id           :integer          not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  filterset_id :integer
#  word_id      :integer
#
# Indexes
#
#  index_filter_words_on_filterset_id  (filterset_id)
#  index_filter_words_on_word_id       (word_id)
#

class FilterWord < ApplicationRecord
  include ArelHelpers::ArelTable
  belongs_to :word
  belongs_to :filterset
  has_many :filtered_messages, dependent: :destroy
  validates :word, presence: true
end
