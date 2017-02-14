json.categories @selected_categories do |category|
  json.id category['id']
  json.name category['name']
  json.default category['default']
end

json.keywords do |_|
  json.array! @keywords
end

