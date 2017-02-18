class RepositoryLanguage < ActiveRecord::Base
  belongs_to :repository
  belongs_to :word
end
