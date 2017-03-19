class FilterWord < ActiveRecord::Base
  include ArelHelpers::ArelTable
  belongs_to :word
  belongs_to :filterset, counter_cache: true
  has_many :filtered_messages, dependent: :destroy
  validates_presence_of :word
end
