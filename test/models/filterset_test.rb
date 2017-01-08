require 'test_helper'

class FiltersetTest < ActiveSupport::TestCase
  setup do
    @profanity = filtersets(:profanity)
    @profane_commit = commits(:profane_commit)
    @happy = filtersets(:happy)
  end

  test 'filtersets should be valid' do
    assert @profanity.valid?
    assert @profanity.filter_words.count > 0
    assert @happy.filter_words.count > 0
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

  test 'execute will create a valid FilteredMessage after matching' do
    assert_difference('FilteredMessage.count', +1) do
      filtered_message = @profanity.execute(@profane_commit)
      assert filtered_message.valid?
    end
  end

end
