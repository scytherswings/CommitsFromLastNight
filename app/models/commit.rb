class Commit < ActiveRecord::Base
  validates_presence_of :raw_node, :username, :message, :repository
end
