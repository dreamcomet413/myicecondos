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
    Crm::Lead.delay.send_to_crm lead_params
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
    Crm::Lead.delay.send_to_crm lead_params
  end
end
