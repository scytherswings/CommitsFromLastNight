# frozen_string_literal: true

# == Schema Information
#
# Table name: filtered_messages
#
#  id             :integer          not null, primary key
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  commit_id      :integer
#  filter_word_id :integer
#  filterset_id   :integer
#
# Indexes
#
#  index_filtered_messages_on_commit_id       (commit_id)
#  index_filtered_messages_on_filter_word_id  (filter_word_id)
#  index_filtered_messages_on_filterset_id    (filterset_id)
#

class FilteredMessage < ApplicationRecord
  include ArelHelpers::ArelTable
  belongs_to :commit
  belongs_to :filterset
  belongs_to :filter_word
  validates :commit, :filterset, :filter_word, presence: true
end
