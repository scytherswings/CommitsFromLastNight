class ExecuteFilters
  include Sidekiq::Worker
  sidekiq_options(queue: 'filter', retry: 2)

  def perform(commit_id)
    log_level = Rails.env == 'production' ? Logger::WARN : Logger::DEBUG

    ActiveRecord::Base.logger.silence(log_level) do
      if commit_id.nil?
        return
      end

      commit = Commit.find(commit_id)
      if commit.nil?
        logger.error { "Couldn't find commit by id: #{commit_id}." }
        raise StandardError "Commit: #{commit_id} not found."
      end

      Filterset.all.try(:each) do |filter|
        filter.execute(commit)
      end
    end
  end
end
