class RepositoryDecorator < Draper::Decorator
  include Draper::LazyHelpers
  delegate_all
  decorates_associations :user, :commit
  decorates_finders
  def self.collection_decorator_class
    PaginationDecorator
  end

  def make_link
    link_to show_name, repository_path(object.id)
  end

  def show_name
    truncate(object.name, length: 25)
  end

  def import_complete?
    object.first_commit_sha.present?
  end

  def make_avatar_link(css_class='profile_avatar')
    link_to(image_tag(object.avatar_uri, class: css_class), object.resource_uri)
  end
end
