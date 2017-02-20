class RepositoryLanguage < ActiveRecord::Base
  include ArelHelpers::ArelTable
  belongs_to :repository
  belongs_to :word
  validates_presence_of :word, :repository
end
