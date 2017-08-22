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

require 'test_helper'

class FilterWordTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
