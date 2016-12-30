require 'test_helper'

class FiltersetTest < ActiveSupport::TestCase
  setup do
    @profanity = filtersets(:profanity)
    @profane_commit = commits(:profane_commit)
    @happy = filtersets(:happy)
    @whitelist_only = filtersets(:whitelist_only)
  end

  test 'filtersets should be valid' do
    assert @profanity.valid?
    assert @profanity.black_list_words.count > 0
    assert @profanity.white_list_words.count > 0
    assert @happy.black_list_words.count > 0
    assert @whitelist_only.black_list_words.count == 0
    assert @whitelist_only.white_list_words.count > 0
  end

  test 'execute will create a new FilteredMessage when a match occurs' do
    assert_difference('FilteredMessage.count', +1) do
      @profanity.execute(@profane_commit)
    end
  end

  test 'execute will not create a new FilteredMessage when no matches are found' do
    assert_difference('FilteredMessage.count', +0) do
      @happy.execute(@profane_commit)
    end
  end

  test 'execute will not create a new FilteredMessage with whitelist only' do
    assert_difference('FilteredMessage.count', +0) do
      @whitelist_only.execute(@profane_commit)
    end
  end

  test 'execute will create a valid FilteredMessage after matching' do
    filtered_message = assert_difference('FilteredMessage.count', +1) do
      @profanity.execute(@profane_commit)
    end
    assert filtered_message.valid?
  end

end
