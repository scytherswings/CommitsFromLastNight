class CommitDecorator < Draper::Decorator
  include Draper::LazyHelpers
  delegate_all
  decorates_associations :user, :repository

  def self.collection_decorator_class
    PaginationDecorator
  end

 def show_message
   truncate(object.message, length: 500)
 end

  def distance_of_time
    distance_of_time_in_words_to_now(commit.utc_commit_time) + ' ago'
  end

  def show_small_time
    "<small>#{object.utc_commit_time}</small>".html_safe
  end
end
