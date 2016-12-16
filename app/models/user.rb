class User < ActiveRecord::Base
  has_many :commits
end
