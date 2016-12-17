class BlackListWord < ActiveRecord::Base
  has_one :word
  belongs_to :filterset
end
