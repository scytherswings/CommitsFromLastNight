# frozen_string_literal: true

json.extract! category, :id, :name
json.url category_url(category, format: :json)
