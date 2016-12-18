class Repository < ActiveRecord::Base
  has_many :commits
  has_many :users, through: :commits
end
