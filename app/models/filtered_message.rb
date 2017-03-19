class FilteredMessage < ActiveRecord::Base
  include ArelHelpers::ArelTable
  belongs_to :commit
  belongs_to :filterset, counter_cache: true
  belongs_to :filter_word, counter_cache: true
  validates_presence_of :commit, :filterset, :filter_word
end
