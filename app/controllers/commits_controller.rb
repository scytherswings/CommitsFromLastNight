require 'will_paginate/array'
require 'arel-helpers'

class CommitsController < ApplicationController
  before_action :set_commit, only: [:show]

  # GET /commits
  # GET /commits.json
  def index
    log_level = Rails.env == 'production' ? Logger::WARN : Logger::DEBUG

    ActiveRecord::Base.logger.silence(log_level) do

      @categories = Rails.cache.fetch('categories', expires_in: 24.hours) do
        Category.all.order('name').as_json
      end

      if params[:categories].blank?
        @list_of_category_ids = Rails.cache.fetch('categories/default', expires_in: 24.hours) { Category.select(Category[:id]).where(default: true).map(&:id).as_json }
      else
        selected_categories = params[:categories]
        if selected_categories.is_a? String
          selected_categories = params[:categories].gsub(/\s+/, '').split(',')
        end
        @list_of_category_ids = selected_categories.reject { |i| /\D+/.match(i) }.uniq.sort
      end
      cleaned_categories_params = @list_of_category_ids.join(',')
      Rails.logger.error { @list_of_category_ids }
      @selected_categories = Rails.cache.fetch("categories_by_id/#{cleaned_categories_params}", expires_in: 24.hours) do
        Category.select([Category[:id], Category[:name], Category[:default]]).where(id: @list_of_category_ids).as_json
      end

      if @list_of_category_ids.flatten == ['0']
        Rails.logger.warn { 'Someone requested no filter! Returning all commits' }
        @commits = Commit.all
                       .order('utc_commit_time desc')
                       .paginate(page: params[:page])
                       .decorate
      else
        @commits = Commit.select(
            [
                Commit[:id],
                Commit[:utc_commit_time],
                Commit[:message],
                Commit[:user_id],
                Commit[:repository_id],
                Commit[:branch_name],
                Commit[:sha]
            ])
                       .where(Filterset[:category_id].in(@list_of_category_ids))
                       .joins(
                           Commit.arel_table
                               .join(FilteredMessage.arel_table)
                               .on(Commit[:id].eq(FilteredMessage[:commit_id]))
                               .join_sources)
                       .joins(
                           Commit.arel_table
                               .join(Filterset.arel_table)
                               .on(FilteredMessage[:filterset_id].eq(Filterset[:id]))
                               .join_sources)
                       .order('utc_commit_time desc')
                       .uniq
                       .paginate(page: params[:page])
                       .decorate #.reverse_order isn't working for some reason and I don't care enough to figure out why
      end

      respond_to do |format|
        format.html
        format.js
        format.json
      end
    end
  end

  def highlight_keywords
    if params[:categories].blank?
      list_of_category_ids = Rails.cache.fetch('categories/default', expires_in: 24.hours) { |_| Category.all.where(default: true).map(&:id) }
    else
      list_of_category_ids = params[:categories].reject { |i| /\D+/.match(i) }.uniq.sort
    end
    cleaned_categories_params = list_of_category_ids.join(',')

    @selected_categories = Rails.cache.fetch("categories_by_id/#{cleaned_categories_params}", expires_in: 24.hours) do
      Category.where(id: list_of_category_ids)
    end

    @keywords = Rails.cache.fetch("highlight_keywords/#{cleaned_categories_params}", expires_in: 24.hours) do
      Word.select(Word[:value])
          .joins(
              Word.arel_table.join(FilterWord.arel_table).on(Word[:id].eq(FilterWord[:word_id])).join_sources)
          .joins(
              Word.arel_table.join(Filterset.arel_table).on(Filterset[:id].eq(FilterWord[:filterset_id])).join_sources)
          .where(Filterset[:category_id].in(list_of_category_ids))
          .joins(
              Word.arel_table.join(FilteredMessage.arel_table).on(FilteredMessage[:filterset_id].eq(Filterset[:id])).join_sources)
          .joins(
              Word.arel_table.join(Commit.arel_table).on(FilteredMessage[:commit_id].eq(Commit[:id])).join_sources)
          .uniq
          .flatten
          .map(&:value)
          .each { |word| Regexp.escape(word) }
          .as_json
    end
  end

  def clear_cache
    Rails.cache.clear
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
