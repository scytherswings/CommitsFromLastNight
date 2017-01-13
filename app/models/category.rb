class Category < ActiveRecord::Base
  has_many :filtersets, dependent: :destroy
  has_many :filtered_messages, through: :filtersets
  has_many :commits, through: :filtered_messages

  validates_presence_of :name, unique: true
end
