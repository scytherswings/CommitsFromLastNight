require 'test_helper'

class CategoriesControllerTest <  ActionDispatch::IntegrationTest
  setup do
    @category = categories(:profanity)
  end

  test "should get index" do
    get categories_url
    assert_response :success
    assert_not_nil assigns(:categories)
  end

  test "should show category" do
    get categories_url(@category)
    assert_response :success
  end

end
