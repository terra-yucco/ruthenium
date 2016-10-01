require 'rakuten_web_service'

class RecipeController < ApplicationController
  def pickup
    rakuten_api
    @menus = RakutenWebService::Recipe.ranking(15)
  end

  # Test Page
  def index
    rakuten_api
    
    @large_categories = RakutenWebService::Recipe.large_categories
    @menus = RakutenWebService::Recipe.ranking(15)

    @title = 'rakuten_recipe_test'
  end

  private
    # For Rakuten API Setting
    def rakuten_api
      RakutenWebService.configure do |c|
        c.application_id = ENV["APPID"]
        c.affiliate_id = ENV["AFID"]
      end
    end
end
