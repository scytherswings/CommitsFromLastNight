# == Schema Information
#
# Table name: users
#
#  id            :integer          not null, primary key
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  account_name  :string           not null
#  avatar_uri    :string
#  commits_count :integer
#  resource_uri  :string
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'Users can be imported' do
    @changesets['changesets'].first do |changeset|
      email = /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i.match(changeset['raw_author']).to_s
      account_name = changeset['author']
      user = User.create!(account_name: account_name)
      EmailAddress.create!(email: email, user: user)
    end
  end


  # test 'a user with two emails is valid' do
  #
  # end


end
