# frozen_string_literal: true

class BitbucketController < ApplicationController
  skip_before_action :verify_authenticity_token
  http_basic_authenticate_with name: 'admin', password: ENV['ADMIN_PASSWORD']

  def fetch_historical_commits
    @commits_to_get_from_each_repo = Integer(params[:commits_to_get_from_each_repo] || 50)
    @jobs_in_queue = Sidekiq::Queue.new('bitbucket').size
    BitbucketHistorical.perform_async(@commits_to_get_from_each_repo)
    respond_to do |format|
      format.json
    end
  end

  def fetch_latest_commits
    BitbucketLatest.perform_async
    @jobs_in_queue = Sidekiq::Queue.new('bitbucket').size
    @jobs_in_progress =
      respond_to do |format|
        format.json
      end
  end

  def fetch_all_repositories
    BitbucketRepos.perform_async
    respond_to do |format|
      format.json
    end
  end

  def clear_queue
    @existing_jobs = Sidekiq::Queue.new('bitbucket').size
    Sidekiq::Queue.new('bitbucket').clear
    @remaining_jobs = Sidekiq::Queue.new('bitbucket').size
    respond_to do |format|
      format.json
    end
  end
end
