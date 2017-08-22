# == Schema Information
#
# Table name: filter_words
#
#  id           :integer          not null, primary key
#  word_id      :integer
#  filterset_id :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class FilterWord < ActiveRecord::Base
  include ArelHelpers::ArelTable
  belongs_to :word
  belongs_to :filterset
  has_many :filtered_messages, dependent: :destroy
  validates_presence_of :word
end
