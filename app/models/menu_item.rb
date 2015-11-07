class MenuItem < ActiveRecord::Base
  belongs_to :menu_location
  default_scope { order(:sort_order) }
end
