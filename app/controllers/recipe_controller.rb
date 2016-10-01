require 'rakuten_web_service'

class RecipeController < ApplicationController

  def index
    RakutenWebService.configuration do |c|
      c.application_id = ENV["APPID"]
      c.affiliate_id = ENV["AFID"]
    end

    @large_categories = RakutenWebService::Recipe.large_categories
    @title = 'rakuten_recipe_test'
  end
end
