class User < ActiveRecord::Base
  has_many :commits
  validates_presence_of :email, :author_name, :account_name
  validates_uniqueness_of :email, :account_name
end
