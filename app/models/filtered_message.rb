class FilteredMessage < ActiveRecord::Base
  belongs_to :commit
  belongs_to :filterset
  validates_presence_of :commit
  validates_presence_of :filterset

end
