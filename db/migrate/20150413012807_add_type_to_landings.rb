class AddTypeToLandings < ActiveRecord::Migration
  def change
    add_column :landings, :landing_type, :string
  end
end
