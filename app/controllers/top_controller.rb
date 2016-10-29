class TopController < ApplicationController

  def index
    if cookies.permanent['veg_saved'] then
      @veg_saved = true
      @vegetable_stocks = get_vegetable_stocks cookies
    else
      @veg_saved = false
      # make rundum data
      @vegetable_stocks = Array.new
      vagetable_list = Constants::VEGETABLE_LIST
      vagetable_list.to_a.each do |vagetable|
        vegetable_number = rand(0..5)
        @vegetable_stocks << [vagetable[0], vagetable[1], vegetable_number]
      end
    end
  end
end
