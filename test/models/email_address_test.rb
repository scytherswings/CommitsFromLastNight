# == Schema Information
#
# Table name: email_addresses
#
#  id         :integer          not null, primary key
#  email      :string           not null
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class EmailAddressTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
