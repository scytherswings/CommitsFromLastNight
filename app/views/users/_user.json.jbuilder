json.extract! user, :id, :author_name, :email, :created_at, :updated_at
json.url user_url(user, format: :json)