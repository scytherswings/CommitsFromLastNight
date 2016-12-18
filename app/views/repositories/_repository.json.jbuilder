json.extract! repository, :id, :name, :owner, :first_commit_sha, :created_at, :updated_at
json.url repository_url(repository, format: :json)