class FetchdataController < ApplicationController
  require 'rets'
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper

  def index
    @residentials = smart_listing_create(:residentials, Residential.all, partial: "fetchdata/listing")
    #exit
  end

  def fetch_res_data
    @client = Rets::Client.new({
        login_url: 'http://rets.torontomls.net:6103/rets-treb3pv/server/login',
        username: 'D14rta',
        password: 'Fc$2719',
        version: 'RETS/1.7'
      })

    begin
      @client.login
      @propertyList =  @client.find(:all, :search_type => 'Property', :class => 'ResidentialProperty', :query => '(status=A)', limit: 100)

      File.open("public/alldata.txt", 'w') do |file|
          file.write @propertyList
      end

      store_residential_data(@propertyList, @client)
      render :text => "success...."
    rescue => e
      render :text => "Error...."
    end
  end


   def store_residential_data(property_hash, client)
     property_hash.each do |row|
         new_hash = row.each_with_object({}) do |(k, v), h|
           if Residential.column_names.include? k.downcase
             h[k.downcase] = v
           end
         end
         r = Residential.create!(new_hash)

         photos = client.objects '*', {
           resource: 'Property',
           object_type: 'Photo',
           resource_id: r.ml_num
         }

         photos.each_with_index do |data, index|
           File.open("public/images/property-#{r.id}-#{index.to_s}.jpg", 'wb') do |file|
             file.write data.body
           end
           r.listing_images.create(image_src: "/images/property-#{r.id}-#{index.to_s}.jpg")
         end
     end
   end
end