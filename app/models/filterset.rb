# == Schema Information
#
# Table name: filtersets
#
#  id            :integer          not null, primary key
#  commits_count :integer
#  name          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  category_id   :integer
#
# Indexes
#
#  index_filtersets_on_category_id  (category_id)
#  index_filtersets_on_name         (name)
#

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
    log_level = Rails.env == 'production' ? Logger::WARN : Logger::DEBUG

    ActiveRecord::Base.logger.silence(log_level) do
      filter_word_id_and_word_values = Rails.cache.fetch("filtersets/#{id}/keywords", expires_in: 24.hours) do
        FilterWord.select([FilterWord[:id], Word[:value]]).where(FilterWord[:filterset_id].eq(id)).joins(:word).as_json
      end

      filter_word_id_and_word_values.each do |filter_word_id_and_word_value|
        if commit.message =~ /\b#{Regexp.escape(filter_word_id_and_word_value['value'])}\b/i
          return FilteredMessage.create!(commit: commit, filterset: self, filter_word_id: filter_word_id_and_word_value['id'])
        end
      end
    end
  end

  def update_filterset_from_file(filterset_file)
    filterset_file_hash = convert_filterset_file_to_hash(filterset_file)

    if filterset_file_hash[:name] != name
      logger.error { "Filterset file: #{filterset_file} contains a name: #{filterset_file_hash[:name]} which does not " +
          "match this filterset's name: #{name}. " +
          'If you need a new filterset then use an Importers::Filter script or something.' }
      return
    end

    if filterset_file_hash[:default] != category.default
      logger.warn { "Filterset: #{name} is changing the default setting for category: #{category.name}! New value: #{filterset_file_hash[:default]}" }
      category.update!(default: filterset_file_hash[:default])
    end

    complete_list_of_new_words = Array.new
    filterset_file_hash[:words].each do |filter_word|
      complete_list_of_new_words << Word.find_or_create_by!(value: filter_word)
    end

    current_words = self.filter_words.map { |filter_word| filter_word.word.value }
    removed_words = current_words - filterset_file_hash[:words]
    new_words = filterset_file_hash[:words] - current_words

    logger.debug { "Words being removed: #{removed_words}" }

    self.filter_words.where(FilterWord[:word_id].in(Word.all.where(value: removed_words).map(&:id))).destroy_all

    logger.debug { "Words being added: #{new_words}" }
    new_words.each { |new_word| FilterWord.create(word: Word.find_by(value: new_word), filterset: self) }
    logger.debug { 'Nuking caches for filtersets and their associated keywords' }
    Rails.cache.delete_matched('filtersets/all')
    Rails.cache.delete_matched("filtersets/#{id}/keywords")
  end

  def convert_filterset_file_to_hash(filter_file)
    bl_file = YAML.load_file(filter_file)

    if bl_file.blank?
      raise ArgumentError.new("File: #{filter_file} was empty or unusable. Cannot import filterset.")
    end

    filterset_file_hash = Hash.new
    filterset_file_hash[:name] = bl_file['name']
    filterset_file_hash[:default] = bl_file.fetch('default', false)
    filterset_file_hash[:words] = bl_file['words']
    filterset_file_hash
  end
end
