class Repository < ActiveRecord::Base
  has_many :commits, dependent: :destroy
  has_many :users, through: :commits
end
