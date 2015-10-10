class CreateFavourites < ActiveRecord::Migration
  def change
    create_table :favourites do |t|
      t.integer :user_id
      t.string :favouriteable_type
      t.integer :favouriteable_id

      t.timestamps null: false
    end
  end
end
