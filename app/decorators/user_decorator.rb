class UserDecorator < Draper::Decorator
  include Draper::LazyHelpers
  delegate_all
  decorates_associations :repository, :commit

  def self.collection_decorator_class
    PaginationDecorator
  end

  def make_link(style=nil)
    link_to(show_name, user_path(object.id), style: style)
  end

  def show_name
    truncate(object.account_name, length: 20)
  end

  def make_avatar_link
    link_to(image_tag(object.avatar_uri, class: 'avatar_wrapper'), user_path(object.id))
  end
end
