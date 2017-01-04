require 'test_helper'

class FilterCategoriesControllerTest < ActionController::TestCase
  setup do
    @filter_category = filter_categories(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:filter_categories)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create filter_category" do
    assert_difference('FilterCategory.count') do
      post :create, filter_category: { category_id: @filter_category.category_id, category_id: @filter_category.category_id, filterset_id: @filter_category.filterset_id, filterset_id: @filter_category.filterset_id }
    end

    assert_redirected_to filter_category_path(assigns(:filter_category))
  end

  test "should show filter_category" do
    get :show, id: @filter_category
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @filter_category
    assert_response :success
  end

  test "should update filter_category" do
    patch :update, id: @filter_category, filter_category: { category_id: @filter_category.category_id, category_id: @filter_category.category_id, filterset_id: @filter_category.filterset_id, filterset_id: @filter_category.filterset_id }
    assert_redirected_to filter_category_path(assigns(:filter_category))
  end

  test "should destroy filter_category" do
    assert_difference('FilterCategory.count', -1) do
      delete :destroy, id: @filter_category
    end

    assert_redirected_to filter_categories_path
  end
end
