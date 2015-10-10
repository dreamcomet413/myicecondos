class AddAttachmentBgImageToLandings < ActiveRecord::Migration
  def self.up
    change_table :landings do |t|
      t.attachment :bg_image
    end
  end

  def self.down
    remove_attachment :landings, :bg_image
  end
end
