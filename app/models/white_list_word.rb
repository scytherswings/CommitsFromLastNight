class WhiteListWord < ActiveRecord::Base
  belongs_to :word
  belongs_to :filterset
  validates_presence_of :word
end
