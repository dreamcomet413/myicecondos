class AddFieldsToShowToResidential < ActiveRecord::Migration
  def change
    add_column :residentials, :fields_to_show, :text
  end
end
