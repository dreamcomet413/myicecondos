class AddFieldsToProspectMatches < ActiveRecord::Migration
  def change
    add_column :prospect_matches, :lat, :float
    add_column :prospect_matches, :long, :float
    add_column :prospect_matches, :radius, :integer
  end
end
