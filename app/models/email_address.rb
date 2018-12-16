# frozen_string_literal: true
# == Schema Information
#
# Table name: email_addresses
#
#  id         :integer          not null, primary key
#  email      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#
# Indexes
#
#  index_email_addresses_on_email    (email) UNIQUE
#  index_email_addresses_on_user_id  (user_id)
#

class EmailAddress < ApplicationRecord
  include ArelHelpers::ArelTable
  belongs_to :user
  validates :email, presence: { unique: true }
end
