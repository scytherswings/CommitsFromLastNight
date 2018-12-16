# frozen_string_literal: true

require 'will_paginate/array'
class UsersController < ApplicationController
  before_action :set_user, only: [:show]

  # GET /users
  # GET /users.json
  def index
    Rails.cache.clear
    log_level = Rails.env.production? ? Logger::WARN : Logger::DEBUG
    ActiveRecord::Base.logger.silence(log_level) do
      @users = User.all.order(:id).paginate(page: params[:page]).decorate

      respond_to do |format|
        format.html
        format.js
        format.json
      end
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    log_level = Rails.env.production? ? Logger::WARN : Logger::DEBUG
    ActiveRecord::Base.logger.silence(log_level) do
      @commits = @user.commits.distinct.order(utc_commit_time: :desc).paginate(page: params[:page]).decorate

      respond_to do |format|
        format.html
        format.js
      end
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = UserDecorator.find(params[:id])
    end
end
