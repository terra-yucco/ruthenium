class TopController < ApplicationController

  def index
    if cookies.permanent['veg_saved'] then
        @veg_saved = true
        @vegetable_stocks = get_vegetable_stocks cookies
        @dishes = Array.new

        #手持ちの野菜から０以外を除外
        veg_list = Array.new
        for i in 0..4 do
            if @vegetable_stocks[i][2] != '0' then
                # logger.debug @vegetable_stocks[i][0]
                veg_list.push(@vegetable_stocks[i][0])
            end
        end

        #手持ちの野菜と同じものをレシピから取得
        veg_num = veg_list.length
        veg_ids = Array.new

        for i in 0..veg_num - 1 do
          dish_result = Dish.where("#{veg_list[i]} > 0")
          #logger.debug veg_list[i]
          #logger.debug dish_result.inspect
          dish_result.each do |dish|
            if veg_ids.include?(dish.id) then
            else
                veg_ids.push(dish.id)
                @dishes.push(dish)
            end
          end
        end
    else
        @veg_saved = false
        @no_header = true
        @no_footer = true
        render  action: :start
    end
  end

end
