Sidekiq::Logging.logger = Logger.new("log/sidekiq_#{Rails.env}.log")

if Rails.env == 'production'
  Sidekiq.configure_server do |config|
    config.redis = {url: "redis://#{ENV['SIDEKIQ_REDIS_URI']}/0/#{Rails.env}/sidekiq"}
  end
  Sidekiq.configure_client do |config|
    config.redis = {url: "redis://#{ENV['SIDEKIQ_REDIS_URI']}/0/#{Rails.env}/sidekiq"}
  end
else
  Sidekiq.configure_server do |config|
    config.redis = {url: "redis://127.0.0.1:6379/0/#{Rails.env}/sidekiq"}
  end
  Sidekiq.configure_client do |config|
    config.redis = {url: "redis://127.0.0.1:6379/0/#{Rails.env}/sidekiq"}
  end
end

if Rails.env == 'production'
  Sidekiq::Logging.logger.level = Logger::INFO
end