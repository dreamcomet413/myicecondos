class AddFeaturedToListing < ActiveRecord::Migration
  def change
    add_column :listings, :featured, :boolean
  end
end
