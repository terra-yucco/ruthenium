require 'test_helper'

class RecipeControllerTest < ActionController::TestCase

  # 楽天APIを利用してピックアップレシピが取得できる
  test "should get pickup via rakuten api" do
    get :pickup
    assert_response :success
    assert_not_nil assigns(:menu)
    assert_not_nil assigns(:materials)
  end

  # カテゴリーを指定してレシピを取得できる
  test "should get pickup by category" do
    # サラダカテゴリ
    get :pickup, :category => '18'
    assert_response :success
    assert_not_nil assigns(:menu)
    assert_not_nil assigns(:materials)
  end

  # 野菜登録画面を表示できる
  test "should show add_vegetables" do
    get :add_vegetables
    assert_response :success
  end

  # 野菜登録ページでのCookie保存
  test "should save veg numbers" do
    # 登録（にんじん 2個、玉ねぎ 3個）
    post :regist_vegetables, :carrot => '2', :onion => '3'
    assert_response :redirect 

    assert_equal '2', response.cookies['veg_carrot']
    assert_equal '3', response.cookies['veg_onion']
  end

  # 材料の数量を取得できる
  # @todo 楽天レシピのページ形式と、掲載先レシピの内容に依存している
  # http://recipe.rakuten.co.jp/recipe/1490006283/
  test "should get material amount" do
    get :scrape
    assert_response :success
    result = assigns(:materials)
    assert_not_nil result
    assert (0 < result.length)  # 材料がないということはないはず
    assert_not_nil result.first[0]['materialName']
    assert_not_nil result.first[0]['materialAmount']
  end

  # 買ったものの Cookie保存のテスト追加
  test "should save cookie" do
    get :pickup
    assert_response :success

    # 1つ目の項目をチェック
    get :bought, :material0 => 'on'
    assert_not_nil response.cookies['bought_list']
  end
end
