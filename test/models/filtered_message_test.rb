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

require 'test_helper'

class FilteredMessageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
