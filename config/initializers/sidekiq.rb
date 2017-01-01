Sidekiq::Logging.logger = Logger.new("log/sidekiq_#{Rails.env}.log")

Sidekiq.configure_server do |config|
  config.redis = {url: "redis://127.0.0.1:6379/0/#{Rails.env}"}
end

Sidekiq.configure_client do |config|
  config.redis = {url: "redis://127.0.0.1:6379/0/#{Rails.env}"}
end

Sidekiq::Logging.logger.level = Logger::WARN

