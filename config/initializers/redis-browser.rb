RedisBrowser::Web.class_eval do
  use Rack::Auth::Basic, 'Administrator area' do |username, password|
    username == 'admin' && password == ENV['ADMIN_PASSWORD']
  end
end