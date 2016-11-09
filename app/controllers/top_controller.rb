class TopController < ApplicationController

  def index
    if cookies.permanent['veg_saved'] then
      @veg_saved = true
      @vegetable_stocks = get_vegetable_stocks cookies
    else
      @veg_saved = false
      render  action: :start
    end
  end
end
