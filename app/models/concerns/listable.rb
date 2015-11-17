module Listable
  extend ActiveSupport::Concern

  LISTABLE_ACCESSORS = %w(full_address address province city postal_code street price sale rent bedrooms bathrooms view_count mls description images type city_listing_count title class_name _type unit_num stories slug)

  def full_address
    "#{address}, #{city}, #{province}, #{postal_code}"
  end

  def geocoding_address
    "#{address}, #{city}, #{province}"
  end

  def address
    addr
  end

  def title
    "#{address}, #{city}"
  end

  def province
    county
  end

  def city
    municipality
  end

  def postal_code
    zip
  end

  def street
    st
  end

  def price
    comma_numbers(lp_dol)
  end

  def sale
    s_r == "Sale"
  end

  def rent
    s_r == "Lease"
  end

  def bedrooms
    br
  end

  def bathrooms
    bath_tot
  end

  def view_count
    impressionist_count
  end

  def mls
    ml_num
  end

  def description
    ad_text
  end

  def main_image
    listing_images.sample(1).try(:first).try(:image_src) || "/missing-image.png"
  end

  def images
    listing_images.collect(&:image_src)
  end

  def image_count
    listing_images.count
  end

  def type
    type_own1_out
  end

  def city_listing_count
    self.class.where(municipality: municipality).count
  end

  def class_name
    self.class.to_s
  end

  def _type
    self.class.to_s.parameterize
  end

  def show_json
    self.as_json(methods: LISTABLE_ACCESSORS)
  end

  def self.format_number(num)
    num.gsub(/[^0-9\.]/, "").to_i
  end

  def soft_delete
    self.deleted_at = DateTime.now
    self.save!
  end

  private

  def comma_numbers(number, delimiter = ',')
    number.to_s.reverse.gsub(%r{([0-9]{3}(?=([0-9])))}, "\\1#{delimiter}").reverse
  end
end
