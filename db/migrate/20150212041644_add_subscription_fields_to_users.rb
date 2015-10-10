class AddSubscriptionFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :unsubscribe_all, :boolean
    add_column :users, :newsletter_subscribed, :boolean
  end
end
