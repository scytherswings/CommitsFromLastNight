class AddFilterWordToFilteredMessage < ActiveRecord::Migration[4.2]
  def change
    add_column :filtered_messages, :filter_word_id, :integer
    add_index :filtered_messages, :filter_word_id
  end
end
