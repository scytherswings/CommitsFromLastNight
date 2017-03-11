require 'health_check'

  class RedisChecker
    extend BaseHealthCheck

    def self.check(redis_instance_type, redis_uri)
      begin
        unless defined?(::Redis)
          raise "Wrong configuration. Missing 'redis' gem"
        end
        res = ::Redis.new(url: redis_uri).ping
        res == 'PONG' ? '' : "Redis.ping returned #{res.inspect} instead of PONG"
      rescue Exception => e
        create_error(redis_instance_type, e.message)
      end
    end
  end

