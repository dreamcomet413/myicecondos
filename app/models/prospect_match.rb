class ProspectMatch < ActiveRecord::Base
  belongs_to :user
  validates :title, :city, presence: true

  def self.process_house_alerts
    User.all.each do |u|
      next unless u.prospect_matches.present?
      results = []
      u.prospect_matches.each do |pm|
        search_filters = {}
        search_filters["municipality"] = pm.city if pm.city.present?
        search_filters["min_price"] = pm.min_price.to_s if pm.min_price.present?
        search_filters["max_price"] = pm.max_price.to_s if pm.max_price.present?
        search_filters["search_beds"] = pm.beds if pm.beds.present?
        search_filters["search_bath"] = pm.baths if pm.baths.present?
        search_filters["timestamp"] = 24.hours.ago
        if pm.property_types.present?
          pm.property_types.split(",").each do |f|
            search_filters["type_own1_out"] = f
            results << Listing.search("", search_filters).to_a
          end
        end
      end
      results.flatten!.uniq!
      ListingMailer.house_alert(Listing.where(id: results.collect(&:id)), u).deliver if results.present?
    end
  end
end
