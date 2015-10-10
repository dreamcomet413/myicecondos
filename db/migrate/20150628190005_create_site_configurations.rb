class CreateSiteConfigurations < ActiveRecord::Migration
  def change
    create_table :site_configurations do |t|
      t.float :rebate_percent

      t.timestamps null: false
    end
  end
end
