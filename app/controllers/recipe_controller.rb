require 'rakuten_web_service'
require 'open-uri'
require 'nokogiri'

class RecipeController < ApplicationController

  @@default_category = 15

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

    @menu = menu_array[@recipe_index]
    @materials = scrape_by_url @menu['recipeUrl']
  end

  # Test Page
  def index
    set_rakuten_api_ids
    
    @large_categories = RakutenWebService::Recipe.large_categories
    @menus = RakutenWebService::Recipe.ranking(15)

    @title = 'rakuten_recipe_test'
  end

  # Sample for scrape
  def scrape
    @materials = scrape_by_url 'http://recipe.rakuten.co.jp/recipe/1490006283/'
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
        results.push(['materialName' => result.css("a").text, "materialAmount" => result.css("p").text])
      end
      return results
    end

end
