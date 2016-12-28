require 'silencer/logger'

Rails.application.configure do |config|
  config.middleware.swap Rails::Rack::Logger, Silencer::Logger, :silence => [%r{/sidekiq/}]
end