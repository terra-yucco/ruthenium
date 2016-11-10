require 'test_helper'

class TopControllerTest < ActionController::TestCase

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:no_header)
    assert_not_nil assigns(:no_footer)
  end

  test "should get index with cookie" do
  	# Cookie 設定
  	cookies.permanent['veg_saved'] = true
    get :index
    assert_response :success
    assert_not_nil assigns(:vegetable_stocks)
    assert_not_nil assigns(:dishes)
  end
end
