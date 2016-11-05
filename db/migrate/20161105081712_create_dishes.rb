class CreateDishes < ActiveRecord::Migration
  def change
    create_table :dishes do |t|
      t.integer :recipe_id, null: false
      t.string :recipe_title, null: false
      t.string :img_url, null: false
      t.integer :serving
      t.float :cabbage,default: 0
      t.float :carrot,default: 0
      t.float :onion,default: 0
      t.float :pepper,default: 0
      t.float :potato,default: 0

      t.timestamps null: false
    end
  end
end
