# frozen_string_literal: true

json.categories @selected_categories do |category|
  json.id category['id']
  json.name category['name']
  json.default category['default']
end

json.keywords_count @keywords.size
json.keywords @keywords
