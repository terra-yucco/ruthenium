class TopController < ApplicationController

  # Top
  def index

    # 野菜未登録
    if ! cookies.permanent['veg_saved'] then
      @veg_saved = false
      @no_header = true
      @no_footer = true
      render action: :start, layout: false
      return
    end

    # 野菜登録済
    @veg_saved = true
    @vegetable_stocks = get_vegetable_stocks cookies
    @dishes = Array.new
    @non_dishes = Array.new

    gon.vegetable_stocks = @vegetable_stocks

    # 所持している野菜と所持していない野菜に振り分ける
    veg_list = Array.new
    non_veg_list = Array.new
    for i in 0..4 do
      if @vegetable_stocks[i][2].present? && @vegetable_stocks[i][2] != '0' then
        veg_list.push(@vegetable_stocks[i][0])
      else
        non_veg_list.push(@vegetable_stocks[i][0])
      end
    end

    # 手持ちの野菜と同じものをレシピから取得
    ## 所持している野菜の種類数
    veg_num = veg_list.length

    veg_ids = Array.new
    non_veg_ids = Array.new

    ## 手持ちの野菜を一つずつ、その野菜を含むレシピを探す
    for i in 0..(veg_num - 1) do
      dish_result = Dish.where("#{veg_list[i]} > 0")

      ## レシピ単位ループ
      dish_result.each do |dish|

        ## ない野菜カウンタ
        miss = 0

        ## 持ってない野菜が材料にあるか
        non_veg_list.each do |nonveg|
          ## 持ってない野菜があったらそれを記録
          if dish[nonveg] > 0 then
            miss = miss + 1
          end
        end

        if miss == 0 then
          ## 既にメニューが登録済なら何もしない
          if veg_ids.include?(dish.id) then
          ## メニュー未登録なら表示用変数に追加
          else
            veg_ids.push(dish.id)
            @dishes.push(dish)
          end
        else
          if ! non_veg_ids.include?(dish.id) then
            non_veg_ids.push(dish.id)
            @non_dishes.push(dish)
          end
        end
      end
    end

  end

  def discript
    @veg_saved = false
    @no_header = true
    @no_footer = true
    render action: :start, layout: false
  end
end
