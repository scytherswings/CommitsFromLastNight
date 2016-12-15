json.extract! commit, :id, :username, :user_avatar, :message, :commit_time, :repository, :branch, :created_at, :updated_at
json.url commit_url(commit, format: :json)