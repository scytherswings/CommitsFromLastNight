require 'will_paginate/array'
class RepositoriesController < ApplicationController
  before_action :set_repository, only: [:show]

  # GET /repositories
  # GET /repositories.json
  def index
    @repositories = Repository.all
  end

  # GET /repositories/1
  # GET /repositories/1.json
  def show
    @users = @repository.users.uniq(&:id).paginate(page: params[:page])
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_repository
    @repository = Repository.find(params[:id])
  end
end
