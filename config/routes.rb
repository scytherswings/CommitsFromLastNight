require 'sidekiq/web'
require 'sidekiq-status/web'
Rails.application.routes.draw do
  resources :categories
  resources :repositories
  resources :users
  root 'commits#index'
  resources :commits
  # get 'about' => 'about#about'
  # get 'contact' => 'about#contact'
  namespace :bitbucket do
    post 'fetch_latest_commits'
    post 'fetch_historical_commits'
    post 'fetch_all_repositories'
    post 'clear_queue'
  end

  post 'clear_cache' => 'commits#clear_cache'
  get 'highlight_keywords' => 'commits#highlight_keywords'

  health_check_routes

  mount Sidekiq::Web => '/sidekiq'
  Sidekiq::Web.set :session_secret, Rails.application.secrets[:secret_key_base]

  if Rails.env == 'development'
    mount PgHero::Engine, at: 'pghero', constraints: lambda { |request| /127\.0\.0\.1/.match(request.remote_ip) }
  end
end
