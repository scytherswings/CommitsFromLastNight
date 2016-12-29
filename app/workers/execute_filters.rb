class ExecuteFilters
  include Sidekiq::Worker
  sidekiq_options(queue: 'filter')

  def perform(commit_id)
    commit = Commit.find(id: commit_id)
    filter_sets = FilterSet.all
    execute_filters(filter_sets, commit)
  end

  def execute_filters(filter_sets, commit)
    filter_sets.each do |filter|
      filter.execute(commit)
    end
  end

end
