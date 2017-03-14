class KillableWorker
  include Sidekiq::Worker


  # def perform(*args)
  #   return if killed?
  # end

  def killed?
    Sidekiq.redis {|job| job.exists("killed-#{jid}") }
  end

  def self.kill!(jid)
    Sidekiq.redis {|job| job.setex("killed-#{jid}", 86400, 1)}
  end
end