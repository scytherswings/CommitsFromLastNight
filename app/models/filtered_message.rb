class FilteredMessage < ActiveRecord::Base
  include ArelHelpers::ArelTable
  belongs_to :commit
  belongs_to :filterset
  belongs_to :filter_word
  validates_presence_of :commit, :filterset, :filter_word
end
