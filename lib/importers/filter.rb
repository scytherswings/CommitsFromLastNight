require 'yaml'
require 'csv'
class Filter
  attr_reader :blacklist_words, :whitelist_words

  def initialize
    @blacklist_words = Array.new
    @whitelist_words = Array.new
  end

  def import_yaml(blacklist_file, whitelist_file = nil)
    @blacklist_words = @blacklist_words | YAML.load_file(blacklist_file).flatten
    unless whitelist_file.blank?
      @whitelist_words = @whitelist_words | YAML.load_file(whitelist_file).flatten
    end
  end

  def import_csv(blacklist_file, whitelist_file = nil)
    @blacklist_words = @blacklist_words | CSV.read(blacklist_file).flatten
    unless whitelist_file.blank?
      @whitelist_words = @whitelist_words | CSV.read(whitelist_file).flatten
    end
  end

  def create_filterset(filterset_name)
    blacklist_words = Array.new
    @blacklist_words.each do |word|
      blacklist_words << Word.find_or_create_by!(word: word)
    end

    whitelist_words = Array.new
    @whitelist_words.each do |word|
      whitelist_words << Word.find_or_create_by!(word: word)
    end

    filterset = Filterset.find_or_create_by!(name: filterset_name)

    filterset.update!(blacklist_words: blacklist_words, whitelist_words: whitelist_words)
  end


end