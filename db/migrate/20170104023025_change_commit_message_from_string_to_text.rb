class ChangeCommitMessageFromStringToText < ActiveRecord::Migration
  def change
    change_column :commits, :message, :text
  end
end
