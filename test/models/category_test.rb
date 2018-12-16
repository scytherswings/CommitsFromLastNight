# == Schema Information
#
# Table name: categories
#
#  id            :integer          not null, primary key
#  commits_count :integer
#  default       :boolean          not null
#  name          :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_categories_on_name  (name) UNIQUE
#

require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
