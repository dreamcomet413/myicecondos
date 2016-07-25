class LeadContact < MailForm::Base
  attribute :first_name,      :validate => true
  attribute :last_name,      :validate => true
  attribute :email,     :validate => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i

  attribute :phone
  attribute :requested_info
  attribute :email
  attribute :source
  attribute :lat
  attribute :long
  attribute :listing_info_address
  attribute :listing_info_city
  attribute :listing_info_postal_code
  attribute :listing_info_property_type
  attribute :price_search_radius
  attribute :title
  attribute :user

  attribute :address_street1
  attribute :address_city
  attribute :address_state
  attribute :address_country
  attribute :address_type


  # Declare the e-mail headers. It accepts anything the mail method
  # in ActionMailer accepts.
  def headers
    {
      :subject => "Ice Condos Contact - New Lead for #{first_name} #{last_name}",
      :to => "#{SiteConfiguration.first.try(:contact_us_email)}",
      :from => %("#{first_name} #{last_name}" <#{email}>)
    }
  end
end
