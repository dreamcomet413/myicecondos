class RemoveUnusedTables < ActiveRecord::Migration
  def change
    drop_table :condos
    drop_table :commercials
    drop_table :residentials
  end
end
