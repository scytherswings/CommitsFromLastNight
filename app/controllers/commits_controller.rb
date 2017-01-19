require 'will_paginate/array'
class CommitsController < ApplicationController

  before_action :set_commit, only: [:show]

  # GET /commits
  # GET /commits.json
  def index
    ActiveRecord::Base.logger = Rails.logger

    @categories = Rails.cache.fetch('categories', expires_in: 5.minutes) do
      Category.all.order('name')
    end

    if params[:categories].blank?
      list_of_category_ids = Category.all.where(default: true).map(&:id)

    else
      list_of_category_ids = params[:categories].reject { |i| /\D+/.match(i) }.uniq.sort
    end
    cleaned_categories_params = list_of_category_ids.join(',')

    @commits = Rails.cache.fetch("commits/page/#{params[:page]}/#{cleaned_categories_params}", expires_in: 60.seconds) do
      Commit.select(Arel.star).where(
          Filterset.arel_table[:category_id].in(list_of_category_ids)
      ).joins(
          Commit.arel_table.join(FilteredMessage.arel_table).on(
              Commit.arel_table[:id].eq(FilteredMessage.arel_table[:commit_id])
          ).join_sources
      ).joins(
          Commit.arel_table.join(Filterset.arel_table).on(
              FilteredMessage.arel_table[:filterset_id].eq(Filterset.arel_table[:id])
          ).join_sources
      ).order(:utc_commit_time).reverse_order.paginate(page: params[:page])
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
