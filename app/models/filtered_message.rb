# == Schema Information
#
# Table name: filtered_messages
#
#  id             :integer          not null, primary key
#  filterset_id   :integer
#  commit_id      :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  filter_word_id :integer
#

class FilteredMessage < ActiveRecord::Base
  include ArelHelpers::ArelTable
  belongs_to :commit
  belongs_to :filterset
  belongs_to :filter_word
  validates_presence_of :commit, :filterset, :filter_word
end
