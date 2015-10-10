class AddAttachmentImageToHomepageSliders < ActiveRecord::Migration
  def self.up
    change_table :homepage_sliders do |t|
      t.attachment :image
    end
  end

  def self.down
    remove_attachment :homepage_sliders, :image
  end
end
