# frozen_string_literal: true

require 'test_helper'

class RepositoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @repository = repositories(:toy_app)
  end

  test "should get index" do
    get repositories_url
    assert_response :success
    assert_not_nil assigns(:repositories)
  end

  test "should show repository" do
    get repository_url(@repository)
    assert_response :success
  end
end
