class BitbucketRepos
  include Sidekiq::Worker
  sidekiq_options(queue: 'bitbucket', retry: false)

  def perform
    Importers::Bitbucket.fetch_all_repositories
  end
end
