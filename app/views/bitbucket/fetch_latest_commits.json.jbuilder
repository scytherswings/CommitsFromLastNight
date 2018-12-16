# frozen_string_literal: true

json.jobs_in_queue Sidekiq::Queue.new('bitbucket').size
json.status 'success'
