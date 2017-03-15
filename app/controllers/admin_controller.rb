class AdminController < ApplicationController
  skip_before_action :verify_authenticity_token
  http_basic_authenticate_with name: 'admin', password: ENV['ADMIN_PASSWORD']

  def update_env_from_s3
    @rake_output = %x(rake fetch_s3_dotenv)
    respond_to do |format|
      format.json
    end
  end

  def refilter_all_commits
    @total_commits_to_refilter = Commit.all.count
    @existing_jobs_in_default_queue = Sidekiq::Queue.new('default').size
    ReprocessCommits.perform_async
    respond_to do |format|
      format.json
    end
  end

  def clear_cache
    Rails.cache.clear
    respond_to do |format|
      format.json
    end
  end

  def clear_queue
    params.require(:queue)
    @queue_name = params[:queue]
    @existing_jobs = Sidekiq::Queue.new(@queue_name).size
    Sidekiq::Queue.new(@queue_name).clear
    @remaining_jobs = Sidekiq::Queue.new(@queue_name).size
    respond_to do |format|
      format.json
    end
  end
end
