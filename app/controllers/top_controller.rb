class TopController < ApplicationController

  def index
    @vegetable_stocks = get_vegetable_stocks cookies
  end
end
