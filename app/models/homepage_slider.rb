class HomepageSlider < ActiveRecord::Base
  belongs_to :site_configuration
  has_attached_file :image, :default_url => "http://icecondos2.s3.amazonaws.com/default_bg.jpg"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
end
