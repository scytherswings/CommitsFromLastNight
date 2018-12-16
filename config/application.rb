# frozen_string_literal: true

require File.expand_path('boot', __dir__)

require 'rails/all'
require 'dotenv/load'
require 'readthis'
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CommitsFromLastNight
  class Application < Rails::Application
    Dotenv.load(Rails.root.join('.env'))
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    Readthis.fault_tolerant = true
    if Rails.env.production?
      config.cache_store = :readthis_store, { expires_in: 24.hours.to_i, namespace: "cache/#{Rails.env}", redis: { url: 'redis://' + (ENV['REDIS_STORE_URI'] || '') }, driver: :hiredis }
    else
      config.cache_store = :readthis_store, { expires_in: 24.hours.to_i, namespace: "cache/#{Rails.env}", redis: { host: '127.0.0.1', port: 6379, db: 0 }, driver: :hiredis }
    end
  end
end
