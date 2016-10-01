require 'test_helper'

class RecipeControllerTest < ActionController::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "should get pickup via rakuten api" do
    get :pickup
    assert_response :success
    assert_not_nil assigns(:menu)
  end
end
