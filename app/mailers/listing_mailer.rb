class ListingMailer < ActionMailer::Base
  layout "email"
  def share_listing_with_friend details, listing
    @listing = listing
    @details = details
    mail  subject: "Ice Condos: A listing has been shared with you",
          from: details.fetch(:email) || "noreply@icecondos.com",
          to: details.fetch(:friend)
  end

  def house_alert listings, user
    @listings = listings
    mail  subject: "Ice Condos: Home Alerts",
          from: "noreply@icecondos.com",
          to: user.email
  end

end
