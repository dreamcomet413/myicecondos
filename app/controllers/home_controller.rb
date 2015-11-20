class HomeController < ApplicationController
  layout 'application'

  def index
    render layout: "home"
  end

  def privacy
    @title = "Privacy Policy"
    @content = SiteConfiguration.first.try(:privacy_content)
  end

  def terms
    @title = "Terms of Service"
    @content = SiteConfiguration.first.try(:terms_content)
  end

  def cookies_policy
    @title = "Cookies Policy"
    @content = SiteConfiguration.first.try(:cookies_content)
  end

  def about
    @title = "Ice Condos"
    @content = SiteConfiguration.first.try(:about_content)
  end

  def gallery
    @title = "Gallery"
  end

  def sellers
    @title = "Sellers"
    @content = SiteConfiguration.first.try(:sellers_content)
  end

  def buyers
    @title = "Buyers"
    @content = SiteConfiguration.first.try(:buyers_content)
  end

  def resources
    @title = "Resources"
    @content = SiteConfiguration.first.try(:resources_content)
  end

end
