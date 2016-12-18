require 'yaml'
require 'obscenity'
class CommitsController < ApplicationController
  before_action :set_commit, only: [:show]


  # GET /commits
  # GET /commits.json
  def index
    start_time = Time.now
    unfiltered_commits = Rails.cache.fetch('commits/unfiltered_commits', expire_in: 60) do
      logger.debug 'Cache for unfiltered_commits was unpopulated. Populating..'
      Commit.all
    end
    end_time = Time.now
    logger.debug "Fetching #{unfiltered_commits.count} Commits took #{(end_time - start_time).round(2)} seconds."

    @commits = Rails.cache.fetch('commits/filtered_commits', expire_in: 60) do
      logger.debug 'Cache for filtered_commits was unpopulated. Populating..'
      filter_commits(unfiltered_commits)
    end
  end

  def clear_cache
    Rails.cache.clear
    redirect_to '#'
  end

  def destroy_all_commits
    Rails.cache.clear
    Commit.destroy_all
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

  def filter_commits(commits)
    logger.debug 'Entering into the commit filtering block. Hold on to your butts.'
    start = Time.now
    filtered_commits = Array.new
    Parallel.each(commits, in_threads: 16) do |commit|
        if Obscenity.profane? commit.message
          filtered_commits << commit
        end
    end
    finish = Time.now
    logger.debug "Filtering #{commits.length} commits took #{(finish - start).round(2)} seconds."
    filtered_commits
    # commits
  end

end
