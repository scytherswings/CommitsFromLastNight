Rails.application.routes.draw do
  resources :filter_categories
  resources :categories
  resources :white_list_words
  resources :black_list_words
  resources :words
  resources :filtersets
  require 'sidekiq/web'

  resources :repositories
  resources :users
  root 'commits#index'
  resources :commits
  post 'fetch_latest_commits' => 'commits#fetch_latest_commits'
  post 'fetch_old_commits' => 'commits#fetch_old_commits'
  post 'fetch_all_repositories' => 'commits#fetch_all_repositories'
  post 'clear_cache' => 'commits#clear_cache'


  mount Sidekiq::Web => '/sidekiq', constraints: lambda { |request| /127\.0\.0\.1/.match(request.remote_ip) }
  Sidekiq::Web.set :session_secret, Rails.application.secrets[:secret_key_base]

end
