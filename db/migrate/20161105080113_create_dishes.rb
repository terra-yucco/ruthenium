class CreateDishes < ActiveRecord::Migration
  def change
    create_table :dishes do |t|
      t.integer :recipe_id, null:false
      t.string :recipe_title, null:false
      t.string :img_url, null:false
      t.integer :serving, null:false
      t.integer :cabbage, default:0
      t.integer :carrot,default:0
      t.integer :onion,default:0
      t.integer :pepper,default:0
      t.integer :potato,default:0

      t.timestamps null: false
    end
  end
end
