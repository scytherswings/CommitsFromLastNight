CommitsFromLastNight::Application.configure do
  if Rails.env == 'production'
      config.cache_store = :redis_store, "redis://#{ENV['REDIS_STORE_URI']}/0/#{Rails.env}/cache"
  else
    config.cache_store = :redis_store, "redis://127.0.0.1:6379/0/#{Rails.env}/cache"
  end
end