class User < ActiveRecord::Base
  has_many :commits, :email_addresses, :user_names
  validates_presence_of :account_name, unique: true
end
