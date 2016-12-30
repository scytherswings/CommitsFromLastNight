class WhiteListWord < ActiveRecord::Base
  belongs_to :word
  belongs_to :filterset
end
