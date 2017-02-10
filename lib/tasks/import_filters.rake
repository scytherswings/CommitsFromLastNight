require 'importers/filter'

desc 'Imports fresh filterset files'
task import_filters: :environment do
  filter_files = Dir.glob('lib/resources/filter_categories/*.yml')

  filter_files.each do |file|
    Importers::Filter.new.create_filterset_from_file(file)
    Rails.cache.delete_matched('categories_by_id/*')
    Rails.cache.delete_matched('highlight_keywords/*')
  end
end