require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get listings" do
    get :listings
    assert_response :success
  end

  test "should get edit_listing" do
    get :edit_listing
    assert_response :success
  end

end
