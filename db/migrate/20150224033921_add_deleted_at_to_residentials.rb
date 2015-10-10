class AddDeletedAtToResidentials < ActiveRecord::Migration
  def change
    add_column :residentials, :deleted_at, :datetime
  end
end
