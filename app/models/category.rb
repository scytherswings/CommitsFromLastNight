# == Schema Information
#
# Table name: categories
#
#  id            :integer          not null, primary key
#  commits_count :integer
#  default       :boolean          not null
#  name          :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
# Indexes
#
#  index_categories_on_name  (name) UNIQUE
#

class Category < ActiveRecord::Base
  include ArelHelpers::ArelTable
  has_many :filtersets, dependent: :destroy
  has_many :filtered_messages, through: :filtersets
  has_many :commits, through: :filtered_messages

  validates_presence_of :name, unique: true
end
