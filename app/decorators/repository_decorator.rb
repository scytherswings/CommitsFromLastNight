# frozen_string_literal: true

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
    object.first_commit_sha.present? ? 'Complete' : 'Incomplete'
  end

  def make_avatar_link(css_class = 'profile_avatar')
    return "" if object.avatar_uri.blank? || object.resource_uri.blank?

    link_to(image_tag(object.avatar_uri, class: css_class), object.resource_uri)
  end

  def make_language_list
    if !object.repository_languages.empty?
      object.repository_languages.map { |repository_language| repository_language.word.value.humanize }.join(', ')
    else
      'No languages listed :('
    end
  end
end
