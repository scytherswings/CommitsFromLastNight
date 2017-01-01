require 'importers/filter'
desc 'creates the default filterset for profanity'
task create_default_filterset: :environment do
  filter = Importers::Filter.new
  filter.import_yaml('lib/resources/blacklist.yml')
  filter.import_csv('lib/resources/google_bad_words.csv')

  filter.create_filterset('Default profanity filterset')
end
