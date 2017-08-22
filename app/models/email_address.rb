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

class EmailAddress < ActiveRecord::Base
  include ArelHelpers::ArelTable
  belongs_to :user
  validates_presence_of :email, unique: true
end
