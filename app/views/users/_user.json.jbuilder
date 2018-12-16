# frozen_string_literal: true

json.extract! user, :id, :account_name
json.url user_url(user, format: :json)
