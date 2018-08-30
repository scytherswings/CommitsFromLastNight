class ChangeCommitMessageFromStringToText < ActiveRecord::Migration[4.2]
  def change
    change_column :commits, :message, :text
  end
end
