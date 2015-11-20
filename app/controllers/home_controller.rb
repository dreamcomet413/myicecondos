class HomeController < ApplicationController
  layout 'application'

  def index
    render layout: "home"
  end

  def privacy
    @page_title = "Privacy Policy"
    @content = SiteConfiguration.first.try(:privacy_content)
  end

  def terms
    @page_title = "Terms of Service"
    @content = SiteConfiguration.first.try(:terms_content)
  end

  def cookies_policy
    @page_title = "Cookies Policy"
    @content = SiteConfiguration.first.try(:cookies_content)
  end

  def about
    @page_title = "Ice Condos"
    @content = SiteConfiguration.first.try(:about_content)
  end

  def gallery
    @page_title = "Gallery"
  end

  def location
    @page_title = "Location"
  end

  def sellers
    @page_title = "Sellers"
    @content = SiteConfiguration.first.try(:sellers_content)
  end

  def buyers
    @page_title = "Buyers"
    @content = SiteConfiguration.first.try(:buyers_content)
  end

  def resources
    @page_title = "Resources"
    @content = SiteConfiguration.first.try(:resources_content)
  end

end
