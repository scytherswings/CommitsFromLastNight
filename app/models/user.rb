class User < ActiveRecord::Base
  has_many :commits, dependent: :destroy
  has_many :email_addresses, dependent: :destroy
  has_many :repositories, through: :commits

  validates_uniqueness_of :account_name
end
