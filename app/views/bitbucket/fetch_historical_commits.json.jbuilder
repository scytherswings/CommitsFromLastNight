json.commits_to_get_from_each_repo @commits_to_get_from_each_repo
json.jobs_in_queue Sidekiq::Queue.new('bitbucket').size
json.status 'success'