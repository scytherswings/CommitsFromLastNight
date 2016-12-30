require 'test_helper'

class BlackListWordsControllerTest < ActionController::TestCase
  setup do
    @black_list_word = black_list_words(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:black_list_words)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create black_list_word" do
    assert_difference('BlackListWord.count') do
      post :create, black_list_word: {  }
    end

    assert_redirected_to black_list_word_path(assigns(:black_list_word))
  end

  test "should show black_list_word" do
    get :show, id: @black_list_word
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @black_list_word
    assert_response :success
  end

  test "should update black_list_word" do
    patch :update, id: @black_list_word, black_list_word: {  }
    assert_redirected_to black_list_word_path(assigns(:black_list_word))
  end

  test "should destroy black_list_word" do
    assert_difference('BlackListWord.count', -1) do
      delete :destroy, id: @black_list_word
    end

    assert_redirected_to black_list_words_path
  end
end
