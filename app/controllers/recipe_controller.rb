require 'rakuten_web_service'

class RecipeController < ApplicationController
  def pickup
    set_rakuten_api_ids
    
    menus = RakutenWebService::Recipe.ranking(15)
    @menu = menus.first
  end

  def shopping_list

  end

  # Test Page
  def index
    set_rakuten_api_ids
    
    @large_categories = RakutenWebService::Recipe.large_categories
    @menus = RakutenWebService::Recipe.ranking(15)

    @title = 'rakuten_recipe_test'
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
