require 'yaml'
require 'obscenity'
class CommitsController < ApplicationController
  before_action :set_commit, only: [:show, :edit, :update, :destroy]


  # GET /commits
  # GET /commits.json
  def index
    unfiltered_commits = Rails.cache.fetch(Commit.all, expire_in: 30)

    if unfiltered_commits.nil? || unfiltered_commits.length < 1
      logger.warn "The cached value of 'unfiltered_commits' was nil or less than one. Fetching unfiltered commits from database."
      unfiltered_commits = Commit.all
      @commits = filter_commits unfiltered_commits
      return
    end

    @commits = Rails.cache.fetch(filter_commits(unfiltered_commits), expire_in: 60)

    if @commits.nil? || @commits.length < 1
      logger.warn "The cached value of 'filtered_commits' was nil or less than one. Running the filter on the available unfiltered commits."
      @commits = filter_commits(unfiltered_commits)
      return
    end
  end

  # GET /commits/1
  # GET /commits/1.json
  def show
  end

  # GET /commits/new
  def new
    @commit = Commit.new
  end

  def clear_cache
    Rails.cache.clear
    redirect_to '#'
  end


  def fetch_latest_from_bitbucket
    system 'rake RAILS_ENV=' + Rails.env + ' BitBucketAPI:fetch_latest_commits &'

    redirect_to '#'
  end

  #Placeholder for potential github stuff.
  def fetch_latest_from_github
    system 'rake RAILS_ENV=' + Rails.env + ' GitHubAPI:fetch_latest_commits &'

    redirect_to '#'
  end

  # POST /commits
  # POST /commits.json
  def create
    @commit = Commit.new(commit_params)

    respond_to do |format|
      if @commit.save
        format.html { redirect_to @commit, notice: 'Commit was successfully created.' }
        format.json { render :show, status: :created, location: @commit }
      else
        format.html { render :new }
        format.json { render json: @commit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /commits/1
  # PATCH/PUT /commits/1.json
  def update
    respond_to do |format|
      if @commit.update(commit_params)
        format.html { redirect_to @commit, notice: 'Commit was successfully updated.' }
        format.json { render :show, status: :ok, location: @commit }
      else
        format.html { render :edit }
        format.json { render json: @commit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /commits/1
  # DELETE /commits/1.json
  def destroy
    @commit.destroy
    respond_to do |format|
      format.html { redirect_to commits_url, notice: 'Commit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def destroy_all_commits
    Commit.destroy_all
    redirect_to '#'
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

  def filter_commits commits
    filtered_commits = Array.new
    commits.try(:each) do |commit|
      if Obscenity.profane? commit.message
        filtered_commits << commit
      end
    end
    filtered_commits
  end

end
