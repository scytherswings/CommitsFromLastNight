require 'test_helper'

class FiltersetsControllerTest < ActionController::TestCase
  setup do
    @filterset = filtersets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:filtersets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create filterset" do
    assert_difference('Filterset.count') do
      post :create, filterset: {  }
    end

    assert_redirected_to filterset_path(assigns(:filterset))
  end

  test "should show filterset" do
    get :show, id: @filterset
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @filterset
    assert_response :success
  end

  test "should update filterset" do
    patch :update, id: @filterset, filterset: {  }
    assert_redirected_to filterset_path(assigns(:filterset))
  end

  test "should destroy filterset" do
    assert_difference('Filterset.count', -1) do
      delete :destroy, id: @filterset
    end

    assert_redirected_to filtersets_path
  end
end
