require 'rakuten_web_service'

class RecipeController < ApplicationController

  def index
#    @title = 'abc'
    RakutenWebService.configuration do |c|
      c.application_id = ENV["APPID"]
      c.affiliate_id = ENV["AFID"]
    end

    @title = 'rakuten_recipe_test'
  end
end
