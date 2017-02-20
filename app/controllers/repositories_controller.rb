require 'will_paginate/array'
require 'arel-helpers'

class RepositoriesController < ApplicationController
  before_action :set_repository, only: [:show]

  # GET /repositories
  # GET /repositories.json
  def index
    log_level = Rails.env == 'production' ? Logger::WARN : Logger::DEBUG

    ActiveRecord::Base.logger.silence(log_level) do
      @repositories = Repository.all.order(:id).paginate(page: params[:page]).decorate
      respond_to do |format|
        format.html
        format.js
        format.json
      end
    end
  end

  # GET /repositories/1
  # GET /repositories/1.json
  def show
    log_level = Rails.env == 'production' ? Logger::WARN : Logger::DEBUG

    ActiveRecord::Base.logger.silence(log_level) do
      @repository = RepositoryDecorator.find(params[:id])
      @repository_users = User.select([
                                          User[:id],
                                          User[:account_name],
                                          User[:avatar_uri],
                                          User[:resource_uri]
                                      ])
                              .joins(:commits)
                              .where(Commit[:repository_id].eq(@repository.id))
                              .uniq
                              .paginate(page: params[:page])
                              .decorate

      respond_to do |format|
        format.html
        format.js
        format.json
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_repository
    @repository = Repository.find(params[:id])
  end
end
