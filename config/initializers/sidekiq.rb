Sidekiq::Logging.logger = Logger.new("log/sidekiq_#{Rails.env}.log")

redis_config = YAML.load_file(Rails.root.join 'config/redis.yml')
redis_config.merge! redis_config.fetch(Rails.env, {})
redis_config.symbolize_keys!
Sidekiq.configure_server do |config|
  config.redis = { url: "redis://#{redis_config[:host]}:#{redis_config[:port]}/0/sidekiq/#{Rails.env}" }
end
Sidekiq.configure_client do |config|
  config.redis = { url: "redis://#{redis_config[:host]}:#{redis_config[:port]}/0/sidekiq/#{Rails.env}" }
end

if Rails.env == 'production'
  Sidekiq::Logging.logger.level = Logger::INFO
end