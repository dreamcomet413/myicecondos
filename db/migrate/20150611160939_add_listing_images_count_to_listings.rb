class AddListingImagesCountToListings < ActiveRecord::Migration
  def change
    add_column :listings, :listing_images_count, :integer
  end
end
