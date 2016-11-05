require 'test_helper'

class DishesControllerTest < ActionController::TestCase
  setup do
    @dish = dishes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dishes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dish" do
    assert_difference('Dish.count') do
      post :create, dish: { cabbage: @dish.cabbage, carrot: @dish.carrot, img_url: @dish.img_url, onion: @dish.onion, pepper: @dish.pepper, potato: @dish.potato, recipe_id: @dish.recipe_id, recipe_title: @dish.recipe_title, serving: @dish.serving }
    end

    assert_redirected_to dish_path(assigns(:dish))
  end

  test "should show dish" do
    get :show, id: @dish
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @dish
    assert_response :success
  end

  test "should update dish" do
    patch :update, id: @dish, dish: { cabbage: @dish.cabbage, carrot: @dish.carrot, img_url: @dish.img_url, onion: @dish.onion, pepper: @dish.pepper, potato: @dish.potato, recipe_id: @dish.recipe_id, recipe_title: @dish.recipe_title, serving: @dish.serving }
    assert_redirected_to dish_path(assigns(:dish))
  end

  test "should destroy dish" do
    assert_difference('Dish.count', -1) do
      delete :destroy, id: @dish
    end

    assert_redirected_to dishes_path
  end
end
