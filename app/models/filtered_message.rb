class FilteredMessage < ActiveRecord::Base
  belongs_to :commit
  belongs_to :filterset
end
