class FilterCategory < ActiveRecord::Base
  belongs_to :filterset
  belongs_to :category
  validates_presence_of :filterset, :category
end
