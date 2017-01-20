class FilteredMessage < ActiveRecord::Base
  include ArelHelpers::ArelTable
  belongs_to :commit
  belongs_to :filterset
  validates_presence_of :commit, :filterset
end
