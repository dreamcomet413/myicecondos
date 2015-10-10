module Crm
  module ApiClient
    @@connection = Faraday.new do |faraday|
      faraday.request   :multipart
      faraday.request   :url_encoded
      faraday.adapter   Faraday.default_adapter
    end
  end
end