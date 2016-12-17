class ForceNonNullOnUserIdForCommits < ActiveRecord::Migration
  def change
    change_column_null :commits, :user_id, false
  end
end
