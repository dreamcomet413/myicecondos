class CreateListingImages < ActiveRecord::Migration
  def change
    create_table :listing_images do |t|
      t.string :imageable_type
      t.integer :imageable_id
      t.string :image_src
    end
  end
end
