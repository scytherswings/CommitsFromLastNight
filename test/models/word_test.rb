# frozen_string_literal: true

# == Schema Information
#
# Table name: words
#
#  id         :integer          not null, primary key
#  value      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_words_on_value  (value) UNIQUE
#

require 'test_helper'

class WordTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
