# frozen_string_literal: true

json.extract! commit, :id, :message, :utc_commit_time
json.user_url user_url(commit.user_id, format: :json)
json.repository_url repository_url(commit.repository_id, format: :json)
json.url commit_url(commit, format: :json)
