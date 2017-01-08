require 'yaml'
require 'csv'
module Importers
  class Filter
    attr_reader :filter_words, :category

    def initialize
      @filter_words = Array.new
    end

    def import_yaml(blacklist_file)
      bl_file = YAML.load_file(blacklist_file)

      @category = bl_file['category']
      @filter_words = @filter_words | bl_file['words']

    end

    def create_filterset(filterset_name)
      filter_words = Array.new
      @filter_words.each do |filter_word|
        filter_words << Word.find_or_create_by!(value: filter_word)
      end

      category = Category.find_or_create_by!(category: @category)

      filterset = Filterset.find_or_create_by!(name: filterset_name, category: category)
      filterset.filter_words.destroy_all
      filter_words.each { |word| FilterWord.create(word: word, filterset: filterset) }

      filterset
    end
  end
end