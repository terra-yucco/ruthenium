class TopController < ApplicationController

  def index
    if cookies.permanent['veg_saved'] then
      @veg_saved = true
      @vegetable_stocks = get_vegetable_stocks cookies
      # 5件取得
      @dishes = Dish.take(5)
    else
      @veg_saved = false
      @no_header = true
      @no_footer = true
      render  action: :start
    end
  end
end
