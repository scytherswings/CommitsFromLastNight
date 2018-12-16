# frozen_string_literal: true

class AddIndexToNode < ActiveRecord::Migration[4.2]
  def change
    add_index :commits, :node
  end
end
