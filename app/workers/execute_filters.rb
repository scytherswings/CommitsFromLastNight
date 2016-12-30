class ExecuteFilters
  include Sidekiq::Worker
  sidekiq_options(queue: 'filter')

  def perform(commit_id)
    commit = Commit.find(id: commit_id)
    filter_sets = Filterset.all
    filter_sets.each do |filter|
      filter.execute(commit)
    end
  end
end
