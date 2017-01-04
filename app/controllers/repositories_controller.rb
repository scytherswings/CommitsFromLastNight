require 'will_paginate/array'
class RepositoriesController < ApplicationController
  before_action :set_repository, only: [:show]

  # GET /repositories
  # GET /repositories.json
  def index
    ActiveRecord::Base.logger.silence(Logger::WARN) do
      @repositories = Repository.all
      respond_to do |format|
        format.html
        format.js
      end
    end
  end

  # GET /repositories/1
  # GET /repositories/1.json
  def show
    ActiveRecord::Base.logger.silence(Logger::WARN) do
      @repository_users = @repository.users.uniq(&:id).paginate(page: params[:page])
      respond_to do |format|
        format.html
        format.js
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_repository
    @repository = Repository.find(params[:id])
  end
end
