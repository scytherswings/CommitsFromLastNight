class Filterset < ActiveRecord::Base
  has_many :white_list_words
  has_many :black_list_words
  has_many :commits, through: :filtered_messages

  def execute(commit)

  end

  def match_black_list_words(commit)
    commit.message.split(/\W+/).each do |message_word|
      black_list_words.each do |word|


      end
    end

  end

  def match_white_list_words

  end


end
