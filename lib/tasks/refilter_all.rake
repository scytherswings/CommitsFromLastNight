require 'resources/scripts/refilter_all_commits'

desc 'Uses a PostgreSQL Cursor to throw all commits back into Redis to have the filters re-executed'
task refilter_all_commits: :environment do
  ReprocessCommits.perform_async
end