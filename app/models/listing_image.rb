class ListingImage < ActiveRecord::Base
  belongs_to :imageable, :polymorphic => true, counter_cache: true
  attr_accessor :file
end
