require 'will_paginate/array'
class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  # GET /users
  # GET /users.json
  def index
    ActiveRecord::Base.logger.silence(Logger::WARN) do
      @users = User.all.paginate(page: params[:page])
      respond_to do |format|
        format.html
        format.js
      end
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    ActiveRecord::Base.logger.silence(Logger::WARN) do
      @commits = @user.commits.order('utc_commit_time DESC').uniq(&:id).paginate(page: params[:page])
      respond_to do |format|
        format.html
        format.js
      end
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end
end
