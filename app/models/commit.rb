class Commit < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :raw_node, :username, :message, :repository
  validates_uniqueness_of :raw_node
end
