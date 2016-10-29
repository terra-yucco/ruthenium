class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private
    # Get vegetable stocks from cookie
    def get_vegetable_stocks (cookies)
      vagetable_list = Constants::VEGETABLE_LIST
      vegetable_stocks = Array.new
      vagetable_list.to_a.each do |vagetable|
        vegetable_number = cookies.permanent['veg_' + vagetable[0].to_s]
        unless vegetable_number then
          vegetable_number = 0
        end
        vegetable_stocks << [vagetable[0], vagetable[1], vegetable_number]
      end
      return vegetable_stocks
    end
end
