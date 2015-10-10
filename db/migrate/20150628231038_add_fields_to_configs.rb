class AddFieldsToConfigs < ActiveRecord::Migration
  def change
    add_column :site_configurations, :privacy_content, :text
    add_column :site_configurations, :terms_content, :text
    add_column :site_configurations, :cookies_content, :text
  end
end
