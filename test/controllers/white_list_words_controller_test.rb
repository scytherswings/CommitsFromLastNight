require 'test_helper'

class WhiteListWordsControllerTest < ActionController::TestCase
  setup do
    @white_list_word = white_list_words(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:white_list_words)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create white_list_word" do
    assert_difference('WhiteListWord.count') do
      post :create, white_list_word: {  }
    end

    assert_redirected_to white_list_word_path(assigns(:white_list_word))
  end

  test "should show white_list_word" do
    get :show, id: @white_list_word
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @white_list_word
    assert_response :success
  end

  test "should update white_list_word" do
    patch :update, id: @white_list_word, white_list_word: {  }
    assert_redirected_to white_list_word_path(assigns(:white_list_word))
  end

  test "should destroy white_list_word" do
    assert_difference('WhiteListWord.count', -1) do
      delete :destroy, id: @white_list_word
    end

    assert_redirected_to white_list_words_path
  end
end
