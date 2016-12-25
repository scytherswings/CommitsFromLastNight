class User < ActiveRecord::Base
  has_many :commits, dependent: :destroy
  has_many :email_addresses, dependent: :destroy
  has_many :repositories, through: :commits

  validates_presence_of :account_name, unique: true
end
