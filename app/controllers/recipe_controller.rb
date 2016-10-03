require 'rakuten_web_service'
require 'open-uri'
require 'nokogiri'

class RecipeController < ApplicationController
  def pickup
    set_rakuten_api_ids
    
    menus = RakutenWebService::Recipe.ranking(15)
    @menu = menus.entries.last
  end

  def shopping_list
    set_rakuten_api_ids
    
    menus = RakutenWebService::Recipe.ranking(15)
    @menu = menus.entries.last
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
    url = 'http://recipe.rakuten.co.jp/recipe/1490006283/'

    charset = nil
    html = open(url) do |f|
      charset = f.charset # 文字種別を取得
      f.read # htmlを読み込んで変数htmlに渡す
    end

    # htmlをパース(解析)してオブジェクトを生成
    doc = Nokogiri::HTML.parse(html, nil, charset)

    materials = []
    doc.css("div.materialBox").css("li").each do |material|
      materials.push(['materialName' => material.css("a").text, "materialAmount" => material.css("p").text])
    end
    @mate = materials

  end

  private
    # For Rakuten API Setting
    def set_rakuten_api_ids
      RakutenWebService.configure do |c|
        c.application_id = ENV["APPID"]
        c.affiliate_id = ENV["AFID"]
      end
    end
end
