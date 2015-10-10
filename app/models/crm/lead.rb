module Crm
  class Lead
    include ApiClient
    BASE_URL = "#{APP_CONFIG[:crm_api_url]}/api/leads/load_from_client"

    def self.send_to_crm(lead_params)
      response = @@connection.post do |req|
        req.url BASE_URL, lead: lead_params, token: APP_CONFIG[:crm_api_token]
      end
    end
  end
end