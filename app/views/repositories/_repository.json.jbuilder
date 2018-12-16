# frozen_string_literal: true

json.extract! repository, :id, :name, :owner, :description, :avatar_uri, :resource_uri
json.import_comlete repository.decorate.import_complete?
json.total_commits repository.commits.size
json.url repository_url(repository, format: :json)
