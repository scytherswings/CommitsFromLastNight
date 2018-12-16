# frozen_string_literal: true

class AddCommitsCountToRepository < ActiveRecord::Migration[4.2]
  def change
    add_column :repositories, :commits_count, :integer
  end
end
