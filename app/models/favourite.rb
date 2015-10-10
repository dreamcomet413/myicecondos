class Favourite < ActiveRecord::Base
  belongs_to :favouriteable, :polymorphic => true
  belongs_to :user

  scope :for_listing, -> (listing) { where("favouriteable_type = ? AND favouriteable_id = ?", listing.class.to_s, listing.id) }
end
