class LandingsController < ApplicationController
  skip_before_filter :verify_authenticity_token, only: [:home_value]
  layout "landing"

  def show
    @landing = Landing.where(slug: params[:slug]).first
    redirect_to root_path and return unless @landing
  end

  def home_value
    lead_params = {
      first_name: params[:full_name].present? ? params[:full_name].split(" ", 2)[0] : nil,
      last_name: params[:full_name].present? ? params[:full_name].split(" ", 2)[1] : nil,
      phone: params[:phone],
      email: params[:email],
      source: URI(request.referer).path,
      lat: request.location.try(:latitude),
      long: request.location.try(:longitude),
      listing_info_lead_is: params[:i_am],
      listing_info_address: params[:street_number].to_s + " " + params[:route].to_s,
      listing_info_city: params[:locality],
      listing_info_postal_code: params[:postal_code],
      title: "Seller"
    }
    # Crm::Lead.delay.send_to_crm lead_params

    contact = LeadContact.new(lead_params)
    contact.request = request
    contact.deliver
  end

  def street_watch
    lead_params = {
      first_name: params[:full_name].present? ? params[:full_name].split(" ", 2)[0] : nil,
      last_name: params[:full_name].present? ? params[:full_name].split(" ", 2)[1] : nil,
      phone: params[:phone],
      email: params[:email],
      source: URI(request.referer).path,
      lat: request.location.try(:latitude),
      long: request.location.try(:longitude),
      listing_info_address: params[:street_number].to_s + " " + params[:route].to_s,
      listing_info_city: params[:locality],
      listing_info_postal_code: params[:postal_code],
      listing_info_property_type: params[:home_type],
      price_search_radius: params[:radius],
      title: "StreetMatch"
    }

    if lead_params[:email].present?
      user = User.where(email: lead_params[:email]).first_or_initialize
      user.assign_attributes(first_name: lead_params[:first_name], last_name: lead_params[:last_name])
      user.password = Devise.friendly_token(8) if user.new_record?
      if user.save
        pm = user.prospect_matches.create(title: "Street Match - #{params[:route]}", city: lead_params[:listing_info_city], property_types: lead_params[:listing_info_property_type], lat: params[:lat], long: params[:lng], radius: lead_params[:price_search_radius])
      end
    end

    # Crm::Lead.delay(priority: 20).send_to_crm lead_params

    contact = LeadContact.new(lead_params)
    contact.request = request
    contact.deliver
  end
end
