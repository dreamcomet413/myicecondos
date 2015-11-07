class AddMetaFieldsToSiteConfigurations < ActiveRecord::Migration
  def change
    add_column :site_configurations, :meta_description, :string
    add_column :site_configurations, :meta_keywords, :string
  end
end
