class AddFieldsToSiteConfigurations < ActiveRecord::Migration
  def change
    add_column :site_configurations, :about_content, :text
    add_column :site_configurations, :sellers_content, :text
    add_column :site_configurations, :buyers_content, :text
    add_column :site_configurations, :resources_content, :text
    add_column :site_configurations, :contact_content, :text
    add_column :site_configurations, :blog_url, :string
    add_column :site_configurations, :facebook_url, :string
    add_column :site_configurations, :twitter_url, :string
    add_column :site_configurations, :contact_us_email, :string
  end
end
