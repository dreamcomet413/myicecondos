class AddLatLongToResidentials < ActiveRecord::Migration
  def change
    add_column :residentials, :latitude, :float
    add_column :residentials, :longitude, :float
  end
end
