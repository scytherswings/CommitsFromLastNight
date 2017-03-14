class BitbucketController < ApplicationController
  skip_before_action :verify_authenticity_token
  http_basic_authenticate_with name: 'admin', password: ENV['ADMIN_PASSWORD']

  def fetch_old_commits
    BitbucketHistorical.perform_async(Integer(params[:commits_to_get_from_each_repo] || 50))
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
end
