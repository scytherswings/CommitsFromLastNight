class ExecuteFilters
  include Sidekiq::Worker
  sidekiq_options(queue: 'filter', retry: 5)

  def perform(commit_id)
    ActiveRecord::Base.logger.silence(Logger::WARN) do
      if commit_id.nil?
        return
      end

      commit = Commit.find(commit_id)
      if commit.nil?
        logger.error "Couldn't find commit by id: #{commit_id}."
        raise StandardError "Commit: #{commit_id} not found."
      end
      filter_sets = Filterset.all
      filter_sets.try(:each) do |filter|
        filter.execute(commit)
      end
    end
  end
end
