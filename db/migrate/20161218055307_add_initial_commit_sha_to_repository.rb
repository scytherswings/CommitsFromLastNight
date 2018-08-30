class AddInitialCommitShaToRepository < ActiveRecord::Migration[4.2]
  def change
    add_column :repositories, :first_commit_sha, :string
  end
end
