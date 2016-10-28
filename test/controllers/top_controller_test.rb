require 'test_helper'

class TopControllerTest < ActionController::TestCase

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:vegetable_stocks)
  end
end
