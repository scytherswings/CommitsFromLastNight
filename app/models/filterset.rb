class Filterset < ActiveRecord::Base
  include ArelHelpers::ArelTable
  has_many :filter_words, dependent: :destroy
  has_many :filtered_messages, dependent: :destroy
  has_many :commits, through: :filtered_messages
  has_many :words, through: :filter_words
  belongs_to :category

  validates_presence_of :name, :category

  # If this proves to be too slow it might be worth it to investigate querying the database for each word in the message
  # against instead of comparing the whole set to every word in the message. That might allow indexes to be leveraged.
  # That being said, I don't think querying the database is very efficient when the keyword set is very small
  # e.g. < 800 words
  def execute(commit)
    Rails.env == 'production' ? log_level = Logger::WARN : log_level = Logger::DEBUG

    ActiveRecord::Base.logger.silence(log_level) do
      filter_word_id_and_word_values = Rails.cache.fetch("filtersets/#{id}/keywords", expires_in: 5.minutes) do
        FilterWord.select([FilterWord[:id], Word[:value]]).where(FilterWord[:filterset_id].eq(id)).joins(:word).eager_load!
      end

      filter_word_id_and_word_values.each do |filter_word_id_and_word_value|
        if commit.message =~ /\b#{filter_word_id_and_word_value.value}\b/i
          return FilteredMessage.create!(commit: commit, filterset: self, filter_word_id: filter_word_id_and_word_value.id)
        end
      end
    end
  end
end
