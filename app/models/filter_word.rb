class FilterWord < ActiveRecord::Base
  include ArelHelpers::ArelTable
  belongs_to :word
  belongs_to :filterset
  validates_presence_of :word
end
