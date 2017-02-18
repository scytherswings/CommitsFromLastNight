class Repository < ActiveRecord::Base
  has_many :commits, dependent: :destroy
  has_many :repository_languages, dependent: :destroy
  has_many :users, through: :commits

  validates_uniqueness_of :name
end
