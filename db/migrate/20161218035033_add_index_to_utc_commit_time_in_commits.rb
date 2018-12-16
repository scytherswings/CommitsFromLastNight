# frozen_string_literal: true

class AddIndexToUtcCommitTimeInCommits < ActiveRecord::Migration[4.2]
  def change
    add_index :commits, :utc_commit_time, order: { utc_commit_time: :desc }
  end
end
