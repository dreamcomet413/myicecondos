class SiteConfiguration < ActiveRecord::Base
  has_many :homepage_sliders
  accepts_nested_attributes_for :homepage_sliders, :allow_destroy => true
end
