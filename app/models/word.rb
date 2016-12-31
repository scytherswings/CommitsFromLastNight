class Word < ActiveRecord::Base
  has_many :white_list_words
  has_many :black_list_words
  has_many :filtersets, through: :black_list_words
  validates_uniqueness_of :word
end
