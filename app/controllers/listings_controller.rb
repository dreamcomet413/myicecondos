require 'will_paginate/array'
class ListingsController < ApplicationController
  respond_to :html, :json

  def show
    @listing = Listing.where(id: params[:id]).first
    @page_title = @listing.full_address

    set_meta_tags title: "#{@page_title}", description: "#{@listing.description}", keywords: "property, listing, realestate, sale, rent, #{@listing.city}, #{@listing.province}, #{@listing.street}, #{@listing.type}"

    set_meta_tags twitter: {
      card:  "product",
      title: @listing.full_address,
      description: @listing.description,
      image: @listing.listing_images.first.try(:image_src),
      data1: "$#{@listing.price}",
      label1: "Price"
    }
    set_meta_tags og: {
      title: @listing.full_address,
      type: @listing.type,
      url: listing_url(@listing),
      image: @listing.listing_images.first.try(:image_src),
      description: @listing.description,
      site_name: "Nicholas Alli",
      price: {
        amount: @listing.price,
        currency: "CAD"
      }
    }

    respond_to do |format|
      format.html {
        impressionist(@listing, "", {unique: [:ip_address]})
      }
      format.json {
        ahoy.track "Started Viewing listing", title: @page_title, id: @listing.id, class_name: @listing.class_name if logged_in?
        render json: @listing.show_json
      }
    end
  end

  def walkscore
    respond_to do |format|
      format.json {
        begin
          render json: JSON.parse(RestClient.get("http://api.walkscore.com/score", {params: {format: "json", lat: params[:lat], lon: params[:lon], wsapikey: APP_CONFIG[:walkscore_token]}}))
        rescue Exception => ex
          render nothing: true
        end
      }
    end
  end

  def leave_page
    @listing = params[:class_name].constantize.where(id: params[:id]).first
    ahoy.track "Viewed listing", id: params[:id], class_name: params[:class_name], title: @listing.full_address, time_spent: ((DateTime.now - current_user.ahoy_events.last.try(:time).try(:to_datetime)) * 24 * 60 * 60).to_i if logged_in?
    respond_to do |format|
      format.js { render nothing: true}
    end
  end

  def map_data
    respond_to do |format|
      format.json {
        @listings = Listing.select('id, latitude, longitude')
        @listings = @listings.paginate(page: params[:page], per_page: params[:per_page])
        render json: @listings
      }
    end
  end

  def request_info
    listing = Listing.where(id: params[:id]).first
    render nothing: true unless listing
    details = params[:request][:details] + " - " + listing_path(listing)
    details += " (#{params[:request][:comments]});" if params[:request][:comments].present?
    lead_params = {
      first_name: params[:request][:first_name],
      last_name: params[:request][:last_name],
      phone: params[:request][:phone_number],
      email: params[:request][:email],
      source: params[:request][:source],
      requested_info: details,
      lat: request.location.try(:latitude),
      long: request.location.try(:longitude),
      listing_info_lead_is: params[:request][:lead_is],
      title: "Home Buyer"
    }
    Crm::Lead.delay.send_to_crm lead_params
    render nothing: true
  end

  def email_friend
    listing = Listing.find params[:id]
    listing.email_friend(params.fetch(:email_friend))
    render nothing: true
  end

  def create_lead
    lead_params = {
      first_name: params[:lead][:first_name],
      last_name: params[:lead][:last_name],
      phone: params[:lead][:phone_number],
      email: params[:lead][:email],
      source: URI(request.referer).path,
      lat: request.location.try(:latitude),
      long: request.location.try(:longitude),
      listing_info_lead_is: params[:lead][:lead_is],
      title: params[:lead][:lead_is] == "Both" ? "Buyer and Seller" : params[:lead][:lead_is]
    }
    Crm::Lead.delay.send_to_crm lead_params
    render nothing: true
  end

  def index
    if params[:autocomplete_form].present?
      params[:province] = params[:administrative_area_level_1]
      params[:city] = params[:locality]
      params[:street] = params[:route]
    end

    location_search = params[:province].present? || params[:city].present? || params[:street].present?

    respond_to do |format|
      format.html {
        @page_title = "Search Results"
        if location_search || params[:query].present?
          @page_title += " - "
          search_params = []
          [:province, :city, :street, :query].each do |key|
            search_params << params[key] if params[key].present?
          end
          @page_title += search_params.join(", ")
        end
      }
      format.json {
        if logged_in? && params[:page] == "1" && params[:notrack].nil?
          ahoy.track "Searched", query: params[:query] if params[:query].present?
          ahoy.track "Advanced Search", search_attributes: JSON.parse(params[:custom_search]) if params[:custom_search].present?
          ahoy.track "Searched Location", location: params.except!(*[:action, :controller, :format, :page]) if location_search
        end
        render json: Listing.where(id: params[:ids]).as_json(only: ['id', 'addr', 'municipality', 'county', 'zip', 'lp_dol', 'ml_num', 'type_own1_out', 'latitude', 'longitude', 'br', 'bath_tot', 'visibility', 'sqft']) and return if params[:ids].present?
        custom_search = params[:custom_search].present? ? JSON.parse(params[:custom_search]) : {}
        custom_search["listing_type"] = params[:listing_type] if params[:listing_type].present?
        custom_search["sort_field"] = params[:sort_field] if params[:sort_field].present?
        if location_search
          custom_search["county"] = params[:province] if params[:province].present?
          custom_search["municipality"] = params[:city] if params[:city].present?
          custom_search["st"] = params[:street] if params[:street].present?
          params[:query] = ""
        end
        @listings = Listing.search(params[:query] || "", custom_search).to_a
        full_count = @listings.count
        @listings = Listing.near([params[:lat], params[:lng]], 10, units: :km).to_a if full_count == 0
        render json: [{count: full_count}] and return if params[:count_only] == "1"
        render json: @listings.as_json(only: ['id']) and return if params[:ids_only] == "1"
        render json: Listing.near([params[:latitude], params[:longitude]], 20, units: :km).sample(params[:sample].to_i || 30).as_json(only: ['id', 'addr', 'municipality', 'county', 'zip', 'lp_dol', 'ml_num', 'type_own1_out', 'latitude',
        'longitude', 'br', 'bath_tot', 'visibility', 'sqft']) << {count: full_count} and return if params[:geolocation]
        unless params[:paginate] == "0"
          ids_to_use = @listings.paginate(page: params[:page], per_page: params[:per_page] || 12).collect(&:id)
          @listings = Listing.where(id: ids_to_use).order("field(id, #{ids_to_use.join(',')})") if ids_to_use.present?
        end
        @listings = Listing.where(id: @listings.sample(params[:sample].to_i).collect(&:id)) if params[:sample]
        render json: @listings.as_json(only: ['id', 'addr', 'municipality', 'county', 'zip', 'lp_dol', 'ml_num', 'type_own1_out', 'latitude', 'longitude', 'br', 'bath_tot', 'visibility', 'sqft']) << {count: full_count}
      }
    end
  end

  def get_listing
    select_listings = if params[:listing_type] == 'featured'
      Listing.where(featured: true).sample(30)
    elsif params[:listing_type] == 'geolocation'
      Listing.near([request.location.try(:data).try(:[], 'latitude'), request.location.try(:data).try(:[], 'longitude')], 20, units: :km).sample(30)
    else
      Listing.where(listing_type: params[:listing_type]).sample(30)
    end

    select_listings = select_listings.map do |listing| {
        id: listing.id,
        img: listing.listing_images.present? ? listing.listing_images.first.image_src : '/assets/image_not_available.jpg',
        addr_num: listing_addr(listing)[:num],
        addr_str: listing_addr(listing)[:str],
        municipality: listing.municipality,
        county: listing.county,
        zip: listing.zip,
        lp_dol: listing.lp_dol ? listing.lp_dol : '0,0',
        ml_num: listing.ml_num ? listing.ml_num : 0 ,
        br: listing.br ? listing.br : 0,
        bath_tot: listing.bath_tot ? listing.bath_tot : 0,
        sqft: listing.sqft ? listing.sqft : 0
      }
    end

    #group to slides
    listings = []
    index_arr = 0
    index_sub_arr = 0

    select_listings.each do |l|
      if index_sub_arr == 0
        index_sub_arr += 1
        listings << [l]
      else
        listings[index_arr] << l
        if index_sub_arr == 2
          index_sub_arr = 0
          index_arr += 1
        else
          index_sub_arr += 1
        end
      end
    end


    respond_to do |format|
      format.html {
        render json: listings.as_json(methods: ["_type"])
      }
    end
  end

  private
  def listing_addr(listing)
    addr = listing.addr
    if addr
      addr = addr.split(' ')
      num = addr[0]
      addr.delete_at(0)
      str = addr.join(' ')
    else
      num = nil
      str = nil
    end
    {num: "##{num}", str: str}
  end
end
