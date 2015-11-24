class ChangeListingSlugIndex < ActiveRecord::Migration
  def up
    remove_index :listings, :slug
    add_index :listings, :slug
  end

  def down
    remove_index :listings, :slug
    add_index :listings, :slug
  end
end
