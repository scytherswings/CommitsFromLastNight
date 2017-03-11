redis_config = YAML.load_file(Rails.root.join 'config/redis.yml')
redis_config.merge! redis_config.fetch(Rails.env, {})
redis_config.symbolize_keys!

CommitsFromLastNight::Application.config.cache_store = :redis_store, "redis://#{redis_config[:host]}:#{redis_config[:port]}/0/#{Rails.env}/cache"