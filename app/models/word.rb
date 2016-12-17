class Word < ActiveRecord::Base
  belongs_to  :white_list_word
  belongs_to  :black_list_word
end
