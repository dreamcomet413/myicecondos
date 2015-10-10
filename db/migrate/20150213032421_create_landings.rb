class CreateLandings < ActiveRecord::Migration
  def change
    create_table :landings do |t|
      t.string :title
      t.string :slug
      t.string :main_heading
      t.string :sub_heading
      t.text :description

      t.timestamps null: false
    end
  end
end
