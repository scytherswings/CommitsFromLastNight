# == Schema Information
#
# Table name: words
#
#  id         :integer          not null, primary key
#  value      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Word < ActiveRecord::Base
  include ArelHelpers::ArelTable
  has_many :filter_words
  has_many :repository_languages
  has_many :repositories, through: :repository_languages
  has_many :filtersets, through: :filter_words
  validates_presence_of :value, unique: true
end
