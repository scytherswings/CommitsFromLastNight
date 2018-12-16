require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  setup do
    @user = users(:scytherswings)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end


  test "should show user" do
    get users_url(@user)
    assert_response :success
  end
end
