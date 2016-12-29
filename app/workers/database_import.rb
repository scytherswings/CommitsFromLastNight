require 'importers/bitbucket'
class DatabaseImport
  include Sidekiq::Worker
  sidekiq_options(queue: 'bitbucket', retry: false)

  def perform(commits_to_import)
    import = Array(commits_to_import)


  end
end