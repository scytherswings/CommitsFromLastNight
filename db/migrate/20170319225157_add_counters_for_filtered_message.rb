class AddCountersForFilteredMessage < ActiveRecord::Migration
  def change
    add_column :filtersets, :filtered_message_count, :integer, default: 0
    add_column :filter_words, :filtered_message_count, :integer, default: 0
  end
end
