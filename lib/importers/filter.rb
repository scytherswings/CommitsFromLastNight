# frozen_string_literal: true

require 'yaml'

module Importers
  class Filter
    attr_reader :filter_words, :name, :default

    def initialize
      @filter_words = []
      @default = false
    end

    def import_yaml(filter_file)
      bl_file = YAML.load_file(filter_file)
      raise StandardError, "File: #{filter_file} was empty or unusable. Skipping." if bl_file.blank?

      @name = bl_file['name']
      @default = bl_file.fetch('default', false)
      @filter_words |= bl_file['words']
    end

    def create_filterset_from_file(filename)
      begin
        import_yaml(filename)
      rescue StandardError => e
        Rails.logger.info("An exception was caught while trying to import file: #{filename}. Not creating filterset. Error: #{e}")
        return
      end
      create_filterset
    end

    def create_filterset(filterset_name: @name, default: @default)
      filter_words = []
      @filter_words.each do |filter_word|
        filter_words << Word.find_or_create_by!(value: filter_word)
      end

      category = Category.find_or_create_by!(name: @name, default: default)

      filterset = Filterset.find_or_create_by!(name: filterset_name, category: category)
      filterset.filter_words.destroy_all
      filter_words.each { |word| FilterWord.create(word: word, filterset: filterset) }

      filterset
    end
  end
end
