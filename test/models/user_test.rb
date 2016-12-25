require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'Users can be imported' do
    @changesets['changesets'].each do |changeset|

      author_name = /\A(?:(?!\s<.*>\z).)+/.match(changeset['raw_author']).to_s
      email = /\b[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i.match(changeset['raw_author']).to_s
      account_name = changeset['author']
      user = User.find_or_create_by!(account_name: account_name)
      email_address = EmailAddress.find_or_create_by!(email: email, user: user)
    end

  end


  test 'a user with two names is valid' do

  end

  test 'a user with two emails is valid' do

  end


end
