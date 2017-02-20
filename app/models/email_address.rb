class EmailAddress < ActiveRecord::Base
  include ArelHelpers::ArelTable
  belongs_to :user
  validates_presence_of :email, unique: true
end
