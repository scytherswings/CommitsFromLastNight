# == Schema Information
#
# Table name: repository_languages
#
#  id            :integer          not null, primary key
#  repository_id :integer          not null
#  word_id       :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class RepositoryLanguage < ActiveRecord::Base
  include ArelHelpers::ArelTable
  belongs_to :repository
  belongs_to :word
  validates_presence_of :word, :repository
end
