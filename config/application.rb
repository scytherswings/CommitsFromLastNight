require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'dotenv/load'
require 'readthis'
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CommitsFromLastNight
  class Application < Rails::Application
    Dotenv.load(Rails.root.join '.env')
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
    Readthis.fault_tolerant = true
    if Rails.env == 'production'
      config.cache_store = :readthis_store, { namespace: "#{Rails.env}/cache", redis: { host: ENV['REDIS_STORE_URI'], port: 6379, db: 0 }, driver: :hiredis }
    else
      config.cache_store = :readthis_store, { namespace: "#{Rails.env}/cache", redis: { host: '127.0.0.1', port: 6379, db: 0 }, driver: :hiredis }
    end
  end
end
