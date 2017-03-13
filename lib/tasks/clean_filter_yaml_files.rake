desc 'cleans up the yaml filterset files'
task clean_yaml: :environment do
  require "#{Rails.root.join '.resources/scripts/clean_yaml'}"
  CleanYaml.clean('../../.resources/filter_categories/')
end