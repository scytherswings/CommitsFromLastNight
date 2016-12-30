class Filterset < ActiveRecord::Base
  has_many :white_list_words
  has_many :black_list_words
  has_many :filtered_messages
  has_many :commits, through: :filtered_messages
  has_many :words, through: :black_list_words

  validates_presence_of :black_list_words

  def execute(commit)
    keywords = (black_list_words.map { |bl| bl.word } - white_list_words.map { |wl| wl.word }).map{|word_obj| word_obj.word}
    message_words = commit.message.split(/\W+/)
    message_words.each do |message_word|
      if keywords.include? message_word
        FilteredMessage.create(commit: commit, filterset: self)
        break
      end
    end
  end
end
