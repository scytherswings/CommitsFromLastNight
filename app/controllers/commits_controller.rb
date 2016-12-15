require 'yaml'
require 'uuidtools'
class CommitsController < ApplicationController
  before_action :set_commit, only: [:show, :edit, :update, :destroy]
  @@config_file = YAML.load_file('config.yml')
  @@bitbucket = BitBucket.new basic_auth: @@config_file['username'] + ':' + @@config_file['password']

  # GET /commits
  # GET /commits.json
  def index
    @commits = Commit.all
  end

  # GET /commits/1
  # GET /commits/1.json
  def show
  end

  # GET /commits/new
  def new
    @commit = Commit.new
  end


  def fetch_latest
    repos = @@bitbucket.repos.list
    logger.debug repos.to_json
    repos.each do |repo|
      logger.debug 'Working on repo: ' + repo['slug']
      changesets = @@bitbucket.repos.changesets.all repo['owner'], repo['slug']
      logger.debug changesets.to_json
      changesets['changesets'].each do |changeset|
        Commit.create(username: changeset['author'], user_avatar: nil, message: changeset['message'], commit_time: changeset['utctimestamp'], repository: repo['slug'], branch: changeset['branch'], raw_node: changeset['raw_node'])
      end
    end

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
