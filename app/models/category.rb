class Category < ActiveRecord::Base
  has_many :filter_categories, dependent: :destroy
  has_many :filtersets, through: :filter_categories
  has_many :filtered_messages, through: :filtersets
  has_many :commits, through: :filtered_messages

  validates_presence_of :category, unique: true
end
