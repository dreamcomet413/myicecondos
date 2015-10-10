class CreateHomepageSliders < ActiveRecord::Migration
  def change
    create_table :homepage_sliders do |t|
      t.integer :site_configuration_id
      t.timestamps null: false
    end
  end
end
