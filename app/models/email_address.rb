class EmailAddress < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :email, unique: true
end
