require 'test_helper'

class FilterWordsControllerTest < ActionController::TestCase
  setup do
    @filter_word = filter_words(:fuck)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:filter_words)
  end

  test "should show filter_word" do
    get :show, id: @filter_word
    assert_response :success
  end
end
