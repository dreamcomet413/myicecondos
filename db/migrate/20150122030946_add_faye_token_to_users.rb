class AddFayeTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :faye_token, :string
  end
end
