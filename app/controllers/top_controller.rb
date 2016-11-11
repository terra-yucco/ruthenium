class TopController < ApplicationController

  def index
    if cookies.permanent['veg_saved'] then
        @veg_saved = true
        @vegetable_stocks = get_vegetable_stocks cookies

        #手持ちの野菜から０以外を除外
        veg_list = Array.new
        @dishes = Array.new
        for i in 0..4 do
            if @vegetable_stocks[i][2] != '0' then
                veg_list.push(@vegetable_stocks[i][0])
            end
        end

        #5件取得
        @dishes = Dish.take(5)
    else
        @veg_saved = false
        @no_header = true
        @no_footer = true
        render  action: :start
    end
  end
end
