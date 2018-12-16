# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id            :integer          not null, primary key
#  account_name  :string           not null
#  avatar_uri    :string
#  commits_count :integer
#  resource_uri  :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_users_on_account_name  (account_name)
#

class User < ApplicationRecord
  include ArelHelpers::ArelTable
  has_many :commits, dependent: :destroy
  has_many :email_addresses, dependent: :destroy
  has_many :repositories, through: :commits

  validates :account_name, uniqueness: true
end
