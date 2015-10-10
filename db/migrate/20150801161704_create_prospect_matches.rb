class CreateProspectMatches < ActiveRecord::Migration
  def change
    create_table :prospect_matches do |t|
      t.string :title
      t.string :city
      t.string :property_types
      t.integer :min_price
      t.integer :max_price
      t.string :beds
      t.string :baths
      t.references :user

      t.timestamps null: false
    end
  end
end
