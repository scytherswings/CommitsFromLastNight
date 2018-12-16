# frozen_string_literal: true

require 'sidekiq'
require 'sidekiq/web'

Sidekiq::Logging.logger = Logger.new("log/sidekiq_#{Rails.env}.log")

if Rails.env.production?
  Sidekiq.configure_server do |config|
    config.redis = { url: "redis://#{ENV['SIDEKIQ_REDIS_URI']}/0/sidekiq/#{Rails.env}/" }
  end
  Sidekiq.configure_client do |config|
    config.redis = { url: "redis://#{ENV['SIDEKIQ_REDIS_URI']}/0/sidekiq/#{Rails.env}/" }
  end
else
  Sidekiq.configure_server do |config|
    config.redis = { url: "redis://127.0.0.1:6379/0/sidekiq/#{Rails.env}/" }
  end
  Sidekiq.configure_client do |config|
    config.redis = { url: "redis://127.0.0.1:6379/0/sidekiq/#{Rails.env}/" }
  end
end

if Rails.env.production?
  Sidekiq::Logging.logger.level = Logger::INFO
  Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
    [user, password] == ['sidekiqadmin', ENV['SIDEKIQ_PASSWORD']]
  end
end
