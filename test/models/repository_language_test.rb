# == Schema Information
#
# Table name: repository_languages
#
#  id            :integer          not null, primary key
#  repository_id :integer          not null
#  word_id       :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

require 'test_helper'

class RepositoryLanguageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
