require 'will_paginate/array'
class CommitsController < ApplicationController
  before_action :set_commit, only: [:show]

  # GET /commits
  # GET /commits.json
  def index
    ActiveRecord::Base.logger = Rails.logger
    @categories = Category.all.order('name')
    @commits = Rails.cache.fetch("commits/page/#{params[:page]}", expires_in: 60.seconds) do
      Category.first.commits.order('utc_commit_time DESC').paginate(page: params[:page])
    end

    respond_to do |format|
      format.html
      format.js
    end
    # end
  end

  def clear_cache
    Rails.cache.clear
    redirect_to '#'
  end

  def fetch_latest_commits
    system 'rake RAILS_ENV=' + Rails.env + ' BitBucketAPI:fetch_latest_commits &'
    redirect_to '#'
  end

  def fetch_old_commits
    BitbucketHistorical.perform_async(100)
    redirect_to '#'
  end


  def fetch_all_repositories
    BitbucketRepos.perform_async
    redirect_to '#'
  end

  #Placeholder for potential github stuff.
  def fetch_latest_from_github
    system 'rake RAILS_ENV=' + Rails.env + ' GitHubAPI:fetch_latest_commits &'
    redirect_to '#'
  end

  # GET /commits/1
  # GET /commits/1.json
  def show
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_commit
    @commit = Commit.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def commit_params
    params.require(:commit).permit(:username, :user_avatar, :message, :commit_time, :repository, :branch, :raw_node)
  end
end
