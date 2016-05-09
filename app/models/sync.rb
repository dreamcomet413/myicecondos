class Sync
  def self.nightly_listing_sync
    load_recent("vow")
    load_recent("idx")
    nightly_cleanup
    update_geocode
    load_location_file
    try_loading_photos
    # ProspectMatch.process_house_alerts
    # Tire.index("listings").delete
    # Listing.import
  end

  def self.reset_photo_count
    Listing.find_each { |listing| Listing.reset_counters(listing.id, :listing_images) }
  end

  def self.try_loading_photos
    client = Rets::Client.new({
      login_url: 'http://rets.torontomls.net:6103/rets-treb3pv/server/login',
      username: 'V15ewy',
      password: 'Vm$5543',
      version: 'RETS/1.7'
    })
    client.login
    Listing.where("visibility = 'vow' AND (listing_images_count IS NULL OR listing_images_count = 0)").each do |l|
      store_photo("vow", l, client)
    end

    client = Rets::Client.new({
      login_url: 'http://rets.torontomls.net:6103/rets-treb3pv/server/login',
      username: 'D14rta',
      password: 'Fc$2719',
      version: 'RETS/1.7'
    })
    client.login
    Listing.where("visibility = 'idx' AND (listing_images_count IS NULL OR listing_images_count = 0)").each do |l|
      store_photo("idx", l, client)
    end
  end

  def self.update_geocode
    Listing.where(latitude: nil).each do |l|
      l.geocode
      l.save
    end
  end

  def self.nightly_cleanup
    client = Rets::Client.new({
      login_url: 'http://rets.torontomls.net:6103/rets-treb3pv/server/login',
      username: 'V15ewy_a',
      password: 'Vm$5543',
      version: 'RETS/1.7'
    })
    client.login

    vow_res = client.find(:all, search_type: 'Property', class: 'ResidentialProperty', :query => "(status=A)").collect{|r| r["Ml_num"]}
    vow_condo = client.find(:all, search_type: 'Property', class: 'CondoProperty', :query => "(status=A)").collect{|r| r["Ml_num"]}

    client = Rets::Client.new({
      login_url: 'http://rets.torontomls.net:6103/rets-treb3pv/server/login',
      username: 'D14rta_a',
      password: 'Fc$2719',
      version: 'RETS/1.7'
    })
    client.login
    idx_res = client.find(:all, search_type: 'Property', class: 'ResidentialProperty', :query => "(status=A)").collect{|r| r["Ml_num"]}
    idx_condo = client.find(:all, search_type: 'Property', class: 'CondoProperty', :query => "(status=A)").collect{|r| r["Ml_num"]}

    active_ml_nums = (vow_res | vow_condo | idx_res | idx_condo)
    Listing.all.each do |l|
      unless active_ml_nums.include?(l.ml_num)
        l.update_attributes(deleted_at: DateTime.now)
        Favourite.where(favouriteable_id: l.id).destroy_all
      end
    end
  end

  def self.load_recent type
    if type == "vow"
      client = Rets::Client.new({
        login_url: 'http://rets.torontomls.net:6103/rets-treb3pv/server/login',
        username: 'V15ewy',
        password: 'Vm$5543',
        version: 'RETS/1.7'
      })
    else
      client = Rets::Client.new({
        login_url: 'http://rets.torontomls.net:6103/rets-treb3pv/server/login',
        username: 'D14rta',
        password: 'Fc$2719',
        version: 'RETS/1.7'
      })
    end
    client.login
    res = client.find(:all, search_type: 'Property', class: 'ResidentialProperty', :query => "(status=A)")
    Sync.store_listing_data(res, "Residential", type, client)
    res = client.find(:all, search_type: 'Property', class: 'CondoProperty', :query => "(status=A)")
    Sync.store_listing_data(res, "Condo", type, client)
  end

  def self.load_location_file
    File.delete("public/map_data/full_data.json") if File.exist?("public/map_data/full_data.json")
    File.open("public/map_data/full_data.json", 'w') do |file|
      hsh = Listing.select("id", "latitude", "longitude").all.inject({}) do |results, listing|
                   results[listing.id] = listing
                   results
                 end.to_json
      file.write hsh
    end
  end

  def self.load_full_vow_set
    client = Rets::Client.new({
      login_url: 'http://rets.torontomls.net:6103/rets-treb3pv/server/login',
      username: 'V15ewy',
      password: 'Vm$5543',
      version: 'RETS/1.7'
    })
    client.login
    File.delete("public/full_vow_res_set.json") if File.exist?("public/full_vow_res_set.json")
    File.open("public/full_vow_res_set.json", 'w') do |file|
      res = client.find(:all, search_type: 'Property', class: 'ResidentialProperty', :query => "(status=A)")
      file.write res
      Sync.store_listing_data(res, "Residential", "vow")
    end
    File.delete("public/full_vow_condo_set.json") if File.exist?("public/full_vow_condo_set.json")
    File.open("public/full_vow_condo_set.json", 'w') do |file|
      res = client.find(:all, search_type: 'Property', class: 'CondoProperty', :query => "(status=A)")
      file.write res
      Sync.store_listing_data(res, "Condo", "vow")
    end
  end

  def self.load_full_idx_set
    client = Rets::Client.new({
      login_url: 'http://rets.torontomls.net:6103/rets-treb3pv/server/login',
      username: 'D14rta',
      password: 'Fc$2719',
      version: 'RETS/1.7'
    })
    client.login
    File.delete("public/full_idx_res_set.json") if File.exist?("public/full_idx_res_set.json")
    File.open("public/full_idx_res_set.json", 'w') do |file|
      res = client.find(:all, search_type: 'Property', class: 'ResidentialProperty', :query => "(status=A)")
      file.write res
      Sync.store_listing_data(res, "Residential", "idx")
    end
    File.delete("public/full_idx_condo_set.json") if File.exist?("public/full_idx_condo_set.json")
    File.open("public/full_idx_condo_set.json", 'w') do |file|
      res = client.find(:all, search_type: 'Property', class: 'CondoProperty', :query => "(status=A)")
      file.write res
      Sync.store_listing_data(res, "Condo", "idx")
    end
  end

   def self.store_listing_data(property_hash, listing_type, visibility, client=nil)
     property_hash.each_with_index do |row, i|
       begin
         puts "\nStart Listing: #{i+1}"
           new_hash = row.each_with_object({}) do |(k, v), h|
             f = k == "DOM" ? k : k.downcase
             if Listing.column_names.include? f
               h[f] = v
             end
           end
           add_listing_check = new_hash["municipality"] == "Toronto" && (new_hash["addr"].include?("14 York") || new_hash["addr"].include?("12 York"))

           if add_listing_check == false
            check = ['C3476313', 'C3447592', 'C3410481', 'C3472512', 'C3460441', 'C3417745', 'C3417382', 'C3476748', 'C3467175', 'C3476321', 'C3476322', 'C3465892', 'C3460989'].include?(new_hash["ml_num"])
           end 

           if add_listing_check
            puts new_hash.inspect
           end
           
           if add_listing_check
             existing = Listing.where(ml_num: new_hash["ml_num"]).first
             if existing.present?
              existing.update_attribute(:deleted_at, nil)
             end
             if existing.present? && existing.visibility == "vow" && visibility == "idx"
               existing.update_attributes(visibility: "idx")
             elsif existing.nil?
               r = Listing.create!(new_hash.merge({visibility: visibility, listing_type: listing_type}))
               store_photo(visibility, r, client)
             end
           end
         puts "\nFinish Listing: #{i+1}"
       rescue Exception => e
         puts "\nstore_residential_data failed for record #{row}\n"
         puts e.inspect
       end

     end
   end

   def self.store_photo type, listing, client
     puts "\nPhotos for listing #{listing.id}\n"
     begin
       photos = client.objects '*', {
         resource: 'Property',
         object_type: 'Photo',
         resource_id: listing.ml_num
       }
       photos.each_with_index do |data, index|
         begin
           s3 = AWS::S3.new
           object = s3.buckets['icecondos2'].objects["listing_photos/listing_#{listing.id}_#{index}.jpg"]
           response = object.write(data.body, acl: :public_read)
           listing.listing_images.create(image_src: "http://icecondos2.s3.amazonaws.com/listing_photos/listing_#{listing.id}_#{index}.jpg")
           puts "#{response}"
         rescue
           puts "File upload failed. #{listing.id}"
         end
       end
     rescue
       puts "store_photos failed. #{listing.id}"
     end
   end

   def self.store_all_vow_photos
     client = Rets::Client.new({
       login_url: 'http://rets.torontomls.net:6103/rets-treb3pv/server/login',
       username: 'V15ewy',
       password: 'Vm$5543',
       version: 'RETS/1.7'
     })
     client.login
     i = 0
     Listing.where(visibility: "vow").each do |listing|
       next if listing.listing_images.present?
       puts "\nPhotos for listing #{listing.id}\n"
       begin
         photos = client.objects '*', {
           resource: 'Property',
           object_type: 'Photo',
           resource_id: listing.ml_num
         }

         photos.each_with_index do |data, index|
           begin
             s3 = AWS::S3.new
             object = s3.buckets['icecondos2'].objects["listing_photos/listing_#{listing.id}_#{index}.jpg"]
             response = object.write(data.body, acl: :public_read)
             listing.listing_images.create(image_src: "http://icecondos2.s3.amazonaws.com/listing_photos/listing_#{listing.id}_#{index}.jpg")
             i += 1
             puts "#{response}"
             puts "count: #{i}"
           rescue
             puts "File upload failed. #{listing.id}"
           end
         end
       rescue
         puts "store_photos failed. #{listing.id}"
       end
     end
   end

   def self.store_all_idx_photos
     client = Rets::Client.new({
       login_url: 'http://rets.torontomls.net:6103/rets-treb3pv/server/login',
       username: 'D14rta',
       password: 'Fc$2719',
       version: 'RETS/1.7'
     })
     client.login
     i = 0
     Listing.where(visibility: "idx").each do |listing|
       next if listing.listing_images.present?
       puts "\nPhotos for listing #{listing.id}\n"
       begin
         photos = client.objects '*', {
           resource: 'Property',
           object_type: 'Photo',
           resource_id: listing.ml_num
         }

         photos.each_with_index do |data, index|
           begin
             s3 = AWS::S3.new
             object = s3.buckets['icecondos2'].objects["listing_photos/listing_#{listing.id}_#{index}.jpg"]
             response = object.write(data.body, acl: :public_read)
             listing.listing_images.create(image_src: "http://icecondos2.s3.amazonaws.com/listing_photos/listing_#{listing.id}_#{index}.jpg")
             i += 1
             puts "#{response}"
             puts "count: #{i}"
           rescue
             puts "File upload failed. #{listing.id}"
           end
         end
       rescue
         puts "store_photos failed. #{listing.id}"
       end
     end
   end
end
