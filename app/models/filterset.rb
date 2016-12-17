class Filterset < ActiveRecord::Base
  has_many :white_list_words
  has_many :black_list_words
  has_many :commits, through: :filtered_messages
end
