# frozen_string_literal: true

require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:scytherswings)
  end

  test "should get index" do
    get users_url
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "should show user" do
    get user_url(@user)
    assert_response :success
  end
end
