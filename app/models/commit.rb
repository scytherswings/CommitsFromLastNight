class Commit < ActiveRecord::Base
  validates_presence_of :raw_node, :username, :message, :repository
  validates_uniqueness_of :raw_node
end
