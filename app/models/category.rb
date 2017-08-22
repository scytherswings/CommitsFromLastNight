# == Schema Information
#
# Table name: categories
#
#  id            :integer          not null, primary key
#  name          :string           not null
#  commits_count :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  default       :boolean          not null
#

class Category < ActiveRecord::Base
  include ArelHelpers::ArelTable
  has_many :filtersets, dependent: :destroy
  has_many :filtered_messages, through: :filtersets
  has_many :commits, through: :filtered_messages

  validates_presence_of :name, unique: true
end
