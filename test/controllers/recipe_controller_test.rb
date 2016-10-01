require 'test_helper'

class RecipeControllerTest < ActionController::TestCase

  test "should get pickup via rakuten api" do
    get :pickup
    assert_response :success
    assert_not_nil assigns(:menu)
  end

  test "should get shopping_list" do
    get :shopping_list
    assert_response :success
    assert_not_nil assigns(:menu)
  end

end
