class CreateMenus < ActiveRecord::Migration
  def change
    create_table :menu_locations do |t|
      t.string :name
      t.string :description
      t.timestamps
    end

    create_table :menu_items do |t|
      t.string :title
      t.string :url
      t.integer :menu_location_id
      t.integer :sort_order
      t.timestamps
    end
  end
end
