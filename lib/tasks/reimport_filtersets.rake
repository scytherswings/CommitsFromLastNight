# frozen_string_literal: true

desc 'Uses a PostgreSQL Cursor to throw all commits back into Redis to have the filters re-executed'
task reimport_filters: :environment do
  filter_files = Dir.glob('lib/resources/filter_categories/*.yml')

  Filterset.all.each do |filterset|
    filter_files.each do |filter_file|
      filterset.update_filterset_from_file(filter_file)
    end
  end
  Rails.cache.delete_matched('categories_by_id/*')
  Rails.cache.delete_matched('highlight_keywords/*')
end
