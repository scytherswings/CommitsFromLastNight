class ExecuteFilters
  include Sidekiq::Worker
  sidekiq_options(queue: 'filter')

  def perform(commit_id)
    ActiveRecord::Base.logger = nil
    if commit_id.nil?
      return
    end
    commit = Commit.find(commit_id)
    filter_sets = Filterset.all
    filter_sets.each do |filter|
      filter.execute(commit)
    end
  end
end
