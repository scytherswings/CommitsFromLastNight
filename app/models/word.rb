class Word < ActiveRecord::Base
  include ArelHelpers::ArelTable
  has_many :filter_words
  has_many :filtersets, through: :filter_words
  validates_presence_of :value, unique: true
end
