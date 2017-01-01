class Filterset < ActiveRecord::Base
  has_many :white_list_words, dependent: :destroy
  has_many :black_list_words, dependent: :destroy
  has_many :filtered_messages, dependent: :destroy
  has_many :commits, through: :filtered_messages
  has_many :words, through: :black_list_words

  validates_presence_of :name

  def execute(commit)
    ActiveRecord::Base.logger.silence(Logger::WARN) do
      keywords = Set.new
      keywords = Rails.cache.fetch("filtersets/#{id}/keywords", expires_in: 5.minutes) do
        (black_list_words.map(&:word) - white_list_words.map(&:word)).map(&:word).each { |keyword| keywords.add(keyword) }
        keywords
      end

      keywords.each do |keyword|
        if commit.message =~ /\b#{keyword}\b/i
          return FilteredMessage.find_or_create_by!(commit: commit, filterset: self)
        end
      end
    end
  end
end
