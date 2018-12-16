# frozen_string_literal: true

require 'redis-browser'
RedisBrowser::Web.class_eval do
  use Rack::Auth::Basic, 'Administrator area' do |username, password|
    username == 'admin' && password == ENV['ADMIN_PASSWORD']
  end
  config = Rails.root.join('config', 'redis-browser.yml')
  settings = YAML.safe_load(ERB.new(IO.read(config)).result)
  RedisBrowser.configure(settings)
end
