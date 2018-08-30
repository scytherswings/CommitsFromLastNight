class ForceNonNullOnUserIdForCommits < ActiveRecord::Migration[4.2]
  def change
    change_column_null :commits, :user_id, false
  end
end
