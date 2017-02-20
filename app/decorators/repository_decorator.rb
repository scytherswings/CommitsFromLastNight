class RepositoryDecorator < Draper::Decorator
  include Draper::LazyHelpers
  delegate_all
  decorates_associations :user, :commit

  def self.collection_decorator_class
    PaginationDecorator
  end

  def make_link
    link_to show_name, repository_path(object.id)
  end

  def show_name
    truncate(object.name, length: 25)
  end
end
