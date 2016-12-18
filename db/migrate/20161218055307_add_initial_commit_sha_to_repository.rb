class AddInitialCommitShaToRepository < ActiveRecord::Migration
  def change
    add_column :repositories, :first_commit_sha, :string
  end
end
