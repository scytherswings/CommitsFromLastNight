require 'health_check'
require 'healthchecks/redis_checker'
HealthCheck.setup do |config|

  # uri prefix (no leading slash)
  config.uri = 'health_check'

  # Text output upon success
  config.success = 'success'

  # Timeout in seconds used when checking smtp server
  # config.smtp_timeout = 30.0

  # http status code used when plain text error message is output
  # Set to 200 if you want your want to distinguish between partial (text does not include success) and
  # total failure of rails application (http status of 500 etc)

  config.http_status_for_error_text = 500

  # http status code used when an error object is output (json or xml)
  # Set to 200 if you want your want to distinguish between partial (healthy property == false) and
  # total failure of rails application (http status of 500 etc)

  config.http_status_for_error_object = 500


  # You can customize which checks happen on a standard health check, eg to set an explicit list use:
  config.standard_checks = %w(database cache)

  # You can set what tests are run with the 'full' or 'all' parameter
  config.full_checks = %w(database migrations cache cache_redis sidekiq_redis)

  # max-age of response in seconds
  # cache-control is public when max_age > 1 and basic_auth_username is not set
  # You can force private without authentication for longer max_age by
  # setting basic_auth_username but not basic_auth_password
  config.max_age = 1

  # Whitelist requesting IPs
  # Defaults to blank and allows any IP
  # config.origin_ip_whitelist = %w(123.123.123.123)

  # http status code used when the ip is not allowed for the request
  config.http_status_for_ip_whitelist_error = 403

  config.add_custom_check('cache_redis') do
    if Rails.env == 'production'
      redis_uri = "redis://#{ENV['REDIS_STORE_URI']}/0/#{Rails.env}/cache"
    else
      redis_uri = "redis://127.0.0.1:6379/0/#{Rails.env}/cache"
    end
    RedisChecker.check('cache_redis', redis_uri)
  end
  config.add_custom_check('sidekiq_redis') do
    if Rails.env == 'production'
      redis_uri = "redis://#{ENV['SIDEKIQ_REDIS_URI']}/0/#{Rails.env}/cache"
    else
      redis_uri = "redis://127.0.0.1:6379/0/#{Rails.env}/cache"
    end
    RedisChecker.check('sidekiq_redis', redis_uri)
  end
end
