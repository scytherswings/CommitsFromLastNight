require 'yaml'
require 'xxhash'

module Importers
  class Filter
    attr_reader :filter_words, :name, :default

    def initialize
      @filter_words = Array.new
      @default = false
    end

    def import_yaml(filter_file)
      yaml_file = YAML.load_file(filter_file)
      if yaml_file.blank?
        raise StandardError.new("File: #{filter_file} was empty or unusable. Skipping.")
      end

      @name = yaml_file['name']
      @default = yaml_file.fetch('default', false)
      @filter_words = @filter_words | yaml_file['words']

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
      filter_words = Array.new
      @filter_words.each do |filter_word|
        filter_words << Word.find_or_create_by!(value: filter_word)
      end

      category = Category.find_or_create_by!(name: @name, default: default)

      filterset = Filterset.find_or_create_by!(name: filterset_name, category: category)
      filterset.filter_words.destroy_all
      filter_words.each { |word| FilterWord.create(word: word, filterset: filterset) }

      filterset
    end

    # This needs to get ALL words because it's possible to add the same word to another filterset
    # which should trigger a filter re-execution
    def generate_version_hash
     XXhash.xxh32(ActiveRecord::Base.connection.execute('SELECT "words"."value" FROM "words" ORDER BY "value" ASC')
                       .map { |element| element['value'] }.to_s)
    end

  end
end