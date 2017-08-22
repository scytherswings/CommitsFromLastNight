# == Schema Information
#
# Table name: categories
#
#  id            :integer          not null, primary key
#  name          :string           not null
#  commits_count :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  default       :boolean          not null
#

require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
