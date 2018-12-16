# frozen_string_literal: true

require 'health_check'
class RedisChecker
  extend BaseHealthCheck

  def self.check(redis_instance_type, redis_uri)
    raise "Wrong configuration. Missing 'redis' gem" unless defined?(::Redis)

    res = ::Redis.new(url: redis_uri).ping
    res == 'PONG' ? '' : "Redis.ping returned #{res.inspect} instead of PONG"
  rescue Exception => e
    create_error(redis_instance_type, e.message)
  end
end
