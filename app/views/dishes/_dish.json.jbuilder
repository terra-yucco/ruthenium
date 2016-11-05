json.extract! dish, :id, :recipe_id, :recipe_title, :img_url, :serving, :cabbage, :carrot, :onion, :pepper, :potato, :created_at, :updated_at
json.url dish_url(dish, format: :json)