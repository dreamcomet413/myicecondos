class Listing < ActiveRecord::Base
  include Listable

  include Tire::Model::Search
  include Tire::Model::Callbacks

  has_many :listing_images, as: :imageable
  has_many :favourites, as: :favouriteable
  is_impressionable

  accepts_nested_attributes_for :listing_images, allow_destroy: true

  geocoded_by :geocoding_address
  after_validation :geocode, on: [:create]

  default_scope { where(deleted_at: nil) }

  mapping do
    indexes :type_own1_out, index: :not_analyzed
    self.columns.reject{|c| %w(type_own1_out).include?(c.name)}.each do |f|
      t = case f.type
      when :datetime
        :date
      when :text
        :string
      when :decimal
        :float
      else
        f.type
      end
      indexes f.name.to_sym, type: t
    end
  end

  def self.search(q_str, additional_attr={})
    tire.search do
      query { string q_str } if q_str.present?
      filter :missing, field: "deleted_at"
      filter :term, s_r: "sale"
      filter :range, listing_images_count: { gte: 1 }

      filter :exists, field: "acres" if additional_attr["acres"].present?
      filter :term, fpl_num: "y" if additional_attr["fpl_num"].present?

      %w(a_c pool waterfront gar_type).each do |f|
        if additional_attr[f].present?
          filter :exists, field: f
          filter :not, {term: {f.to_sym => 'none'}}
        end
      end

      filter :term, type_own1_out: additional_attr["type_own1_out"] if additional_attr["type_own1_out"].present?
      query do
        boolean do
          must { string "county: #{additional_attr["county"]}" } if additional_attr["county"].present?
          must { string "municipality: #{additional_attr["municipality"]}" } if additional_attr["municipality"].present?
          must { string "st: #{additional_attr["st"]}" } if additional_attr["st"].present?
        end
      end
      filter :term, featured: 1 if additional_attr["featured"].present?
      filter :term, listing_type: additional_attr["listing_type"].downcase if additional_attr["listing_type"].present?
      filter :range, created_at: { gte: additional_attr["timestamp"] } if additional_attr["timestamp"].present?

      if additional_attr["min_price"].present? && additional_attr["max_price"].present?
        filter :range, lp_dol: { gte: Listable.format_number(additional_attr["min_price"]), lte: Listable.format_number(additional_attr["max_price"]) }
      elsif additional_attr["min_price"].present?
        filter :range, lp_dol: { gte: Listable.format_number(additional_attr["min_price"]) }
      elsif additional_attr["max_price"].present?
        filter :range, lp_dol: { lte: Listable.format_number(additional_attr["max_price"]) }
      end
      if additional_attr["search_bath"].present?
        if additional_attr["search_bath"].include?("+")
          filter :range, bath_tot: { gte: Listable.format_number(additional_attr["search_bath"]) }
        else
          filter :term, bath_tot: Listable.format_number(additional_attr["search_bath"])
        end
      end
      if additional_attr["search_beds"].present?
        if additional_attr["search_beds"].include?("+")
          filter :range, br: { gte: Listable.format_number(additional_attr["search_beds"]) }
        else
          filter :term, br: Listable.format_number(additional_attr["search_beds"])
        end
      end
      size 25000
      fields {}
      if additional_attr["sort_field"].present?
        sort { by additional_attr["sort_field"].to_sym, additional_attr["sort_field"] == 'lp_dol' ? 'asc' : 'desc' }
      else
        sort { by :timestamp_sql, 'desc' }
      end
    end
  end

  def email_friend email_details
    ListingMailer.share_listing_with_friend(email_details, self).deliver
  end
end
