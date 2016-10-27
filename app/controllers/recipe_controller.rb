require 'rakuten_web_service'
require 'open-uri'
require 'nokogiri'

class RecipeController < ApplicationController

  @@default_category = 15

  def bought_list

    bought_list = cookies[:bought_list]

    bought_list_array = bought_list.split('&')

    @recipeTitle = bought_list_array[1]
    @recipeUrl = bought_list_array[2]
    @materials = eval(bought_list_array[3])
    
    render "bought_list"
  end

  def pickup
    set_rakuten_api_ids
    
    category = params[:category]
    unless category then
      category = session[:category]
    end
    unless category then
      category = @@default_category
    end
    session[:category] = category
    
    #楽天API発行
    menus = RakutenWebService::Recipe.ranking(category)
    menu_array = menus.entries

    #レシピのランダム化
    @recipe_index = rand(0..3)
    session[:recipe_index] = @recipe_index

    @menu = menu_array[@recipe_index]
    @materials = scrape_by_url @menu['recipeUrl']
  end

  # Test Page
  def index
    set_rakuten_api_ids

    @category = params[:category]
    unless @category then
      @category = @default_category
    end

    @large_categories = RakutenWebService::Recipe.large_categories
    @medium_categories = RakutenWebService::Recipe.medium_categories
    @small_categories = RakutenWebService::Recipe.small_categories

    @menus = RakutenWebService::Recipe.ranking(@category)

    @title = 'rakuten_recipe_test'
  end

  # 買ったことにするアクション
  def bought
    set_rakuten_api_ids
    category = session[:category]
    recipe_index = session[:recipe_index]

    #楽天API発行
    menus = RakutenWebService::Recipe.ranking(category)
    menu_array = menus.entries

    @menu = menu_array[recipe_index]
    @materials = scrape_by_url @menu['recipeUrl']

    bought_items = Array.new
    @material_checks = Array.new
    @materials.each_with_index do |material, i|
      if params['material' + i.to_s] == 'on' then
        bought_items << [materialName: material[0]['materialName'], materialAmount: material[0]['materialAmount']]
        @material_checks.push(i)
      end
    end
    serial_time = Time.now.to_i

    # @todo Cookieに保存するデータ構造の検討
    cookies.permanent[:bought_list] = [serial_time, @menu['recipeTitle'], @menu['recipeUrl'], bought_items]

    # 買ったことにする
    @bought = true

    render action: :pickup
    return
  end

  # Sample for scrape
  def scrape
    @materials = scrape_by_url 'http://recipe.rakuten.co.jp/recipe/1570000075/'
    #@materials = scrape_by_url 'http://recipe.rakuten.co.jp/recipe/1490006283/'
  end

  def add_vegetables
    vagetable_list = Constants::VEGETABLE_LIST
    @vegetable_stocks = Array.new
    vagetable_list.to_a.each do |vagetable|
      vegetable_number = cookies.permanent['veg_' + vagetable[0].to_s]
      unless vegetable_number then
        vegetable_number = 0
      end
      @vegetable_stocks << [vagetable[0], vagetable[1], vegetable_number]
    end
  end

  def regist_vegetables
    # render :text => "じゃがいも = #{params[:potato]['potato']}, ニンジン = #{params[:carrot]['carrot']}"
    
    # 接頭辞 veg_ をつけて Cookie に保存
    vagetable_list = Constants::VEGETABLE_LIST
    vagetable_list.to_a.each do |vagetable|
      cookies.permanent['veg_' + vagetable[0].to_s] = params[vagetable[0]]
    end
    redirect_to :root
  end

  private
    # For Rakuten API Setting
    def set_rakuten_api_ids
      RakutenWebService.configure do |c|
        c.application_id = ENV["APPID"]
        c.affiliate_id = ENV["AFID"]
      end
    end

   # Sample for scrape
    def scrape_by_url (url)

      charset = nil
      html = open(url) do |f|
        charset = f.charset # 文字種別を取得
        f.read # htmlを読み込んで変数htmlに渡す
      end

      # htmlをパース(解析)してオブジェクトを生成
      doc = Nokogiri::HTML.parse(html, nil, charset)

      results = []
      doc.css("div.materialBox").css("li").each do |result|
        materialName = result.css("a").text
        if materialName == '' then
          materialName = result.css("div").text
        end
        results.push(['materialName' => materialName, "materialAmount" => result.css("p").text])
      end
      return results
    end

end
