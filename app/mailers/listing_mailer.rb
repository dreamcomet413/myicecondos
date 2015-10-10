class ListingMailer < ActionMailer::Base
  layout "email"
  def share_listing_with_friend details, listing
    @listing = listing
    @details = details
    mail  subject: "Nicholas Alli: A listing has been shared with you",
          from: details.fetch(:email) || "noreply@nicholasalli.com",
          to: details.fetch(:friend)
  end

  def house_alert listings, user
    @listings = listings
    mail  subject: "Nicholas Alli: Home Alerts",
          from: "noreply@nicholasalli.com",
          to: user.email
  end

end
