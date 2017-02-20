json.extract! commit, :id, :message, :utc_commit_time, :repository
json.url commit_url(commit, format: :json)