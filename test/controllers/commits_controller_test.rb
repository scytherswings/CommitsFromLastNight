# frozen_string_literal: true

require 'test_helper'

class CommitsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @commit = commits(:toy_app_commit)
  end

  test "should get index" do
    get commits_url
    assert_response :success
    assert_not_nil assigns(:commits)
  end

  # test "should show commit" do
  #   get :show, id: @commit
  #   assert_response :success
  # end
end
