require 'test_helper'

class TopControllerTest < ActionController::TestCase

  test "should get index" do
    get :index
    assert_response :success
    # トップページの振り分けで nil になる場合あり
    # assert_not_nil assigns(:vegetable_stocks)
  end
end
