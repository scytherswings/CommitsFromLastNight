require 'yaml'
require 'csv'
module Importers
  class Filter
    attr_reader :blacklist_words

    def initialize
      @category = nil
      @blacklist_words = Hash.new
    end

    def import_yaml(blacklist_file)
      bl_file = YAML.load_file(blacklist_file)

      @category = bl_file['category']
      @blacklist_words = @blacklist_words | bl_file['words']

    end

    def create_filterset(filterset_name)
      blacklist_words = Array.new
      @blacklist_words.each do |word|
        blacklist_words << Word.find_or_create_by!(word: word)
      end

      filterset = Filterset.find_or_create_by!(name: filterset_name)
      filterset.black_list_words.destroy_all
      blacklist_words.each { |word| BlackListWord.create(word: word, filterset: filterset) }

      filterset
    end

  end
end