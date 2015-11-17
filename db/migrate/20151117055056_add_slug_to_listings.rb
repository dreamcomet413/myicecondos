class AddSlugToListings < ActiveRecord::Migration
  def change
    add_column :listings, :slug, :string
    add_index :listings, :slug, unique: true
  end
end
