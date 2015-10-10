require 'will_paginate/array'
class AdminController < ApplicationController
  before_action :authenticate_user!
  before_action :verify_admin

  def index
  end

  def listings
    ids = params[:query].present? ? Listing.search(params[:query]).collect(&:id) : Listing.all.pluck(:id)
    @result_count = ids.count
    @listings = Listing.where(id: ids).order("id desc").paginate(page: params[:page], per_page: 25)
  end

  def new_listing
    @listing = Listing.new
  end

  def create_listing
    @listing = Listing.new
    assignment_params = listing_params.clone
    assignment_params["listing_images_attributes"] = assignment_params["listing_images_attributes"].reject{|k,v| v["file"].present?} if assignment_params["listing_images_attributes"]
    @listing.assign_attributes assignment_params
    @listing.fields_to_show = params[:fields_to_show]
    if @listing.save
      process_images(@listing) if listing_params["listing_images_attributes"]
    end
    redirect_to listing_path(@listing)
  end

  def edit_listing
    @listing = Listing.where(id: params[:id]).first if params[:id]
    redirect_to :back, alert: "Could not find the listing" unless @listing
  end

  def update_listing
    @listing = Listing.where(id: params[:id]).first if params[:id]
    assignment_params = listing_params.clone
    assignment_params["listing_images_attributes"] = assignment_params["listing_images_attributes"].reject{|k,v| v["file"].present?} if assignment_params["listing_images_attributes"]
    @listing.assign_attributes assignment_params
    @listing.fields_to_show = params[:fields_to_show]
    if @listing.save
      process_images(@listing) if listing_params["listing_images_attributes"]
    end
    redirect_to listing_path(@listing)
  end

  def destroy_listing
    @listing = Listing.where(id: params[:id]).first if params[:id]
    redirect_to :back, alert: "Could not find the listing" unless @listing
    @listing.soft_delete
    redirect_to admin_listings_path, notice: "Listing has been deleted. Please refresh the page if the listing is still visible."
  end

  def configurations
    @site_configuration = SiteConfiguration.first || SiteConfiguration.create
  end

  def update_configurations
    @site_configuration = SiteConfiguration.first
    @site_configuration.update_attributes(site_configuration_params)
    redirect_to :back, notice: "Saved successfully"
  end

  def user_management
    @admins = User.where(admin: true)
  end

  def add_admin
    user = User.where(email: params[:email]).first
    redirect_to :back, alert: "Could not find the user with the following email: #{params[:email]}" and return unless user.present?
    user.update_attributes(admin: true)
    redirect_to admin_user_management_path, notice: "User has been updated!"
  end

  def remove_admin
    user = User.where(id: params[:id]).first
    redirect_to :back, alert: "Could not find the user with the following email: #{params[:email]}" and return unless user.present?
    user.update_attributes(admin: false)
    redirect_to admin_user_management_path, notice: "Admin access has been removed!"
  end

  private

  def verify_admin
    redirect_to root_path, alert: "You're not an admin." and return unless current_user.admin?
  end

  def listing_params
    params.require(:listing).permit!
  end

  def site_configuration_params
    params.require(:site_configuration).permit!
  end

  def process_images(listing)
    bucket_name = if Rails.env.production? || Rails.env.staging?
                    'nicholasalli'
                  else
                    'nicholasalli-dev'
                  end
    s3 = AWS::S3.new
    params[:listing][:listing_images_attributes].each do |k, v|
      if v["file"].present?
        begin
          object = s3.buckets[bucket_name].objects["listing_photos/listing_#{listing.id}_#{listing.listing_images.count}.jpg"]
          response = object.write(open(v["file"]), acl: :public_read, content_type: v["file"].content_type)
          listing.listing_images.create(image_src: "http://#{bucket_name}.s3.amazonaws.com/listing_photos/listing_#{listing.id}_#{listing.listing_images.count}.jpg")
        rescue
        end
      end
    end
  end
end
