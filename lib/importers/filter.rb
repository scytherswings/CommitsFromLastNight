require 'yaml'
require 'csv'
module Importers
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
      ActiveRecord::Base.logger = nil

      blacklist_words = Array.new
      @blacklist_words.each do |word|
        blacklist_words << Word.find_or_create_by!(word: word)
      end

      whitelist_words = Array.new
      @whitelist_words.each do |word|
        whitelist_words << Word.find_or_create_by!(word: word)
      end

      filterset = Filterset.find_or_create_by!(name: filterset_name)
      filterset.black_list_words.destroy_all
      filterset.white_list_words.destroy_all
      blacklist_words.each {|word| BlackListWord.create(word: word, filterset: filterset)}
      whitelist_words.each {|word| WhiteListWord.create(word: word, filterset: filterset)}

      filterset
    end
end
end