# frozen_string_literal: true

json.extract! @commit, :id, :message, :utc_commit_time, :user, :repository
json.categories @commit.categories
json.filter_words @commit.filter_words.map { |filter_word| filter_word.word.value }.uniq
json.url commit_url(@commit, format: :json)
