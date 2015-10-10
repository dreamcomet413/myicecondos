class HomeController < ApplicationController
  def index
  end

  def privacy
    @content = SiteConfiguration.first.try(:privacy_content)
  end

  def terms
    @content = SiteConfiguration.first.try(:terms_content)
  end

  def cookies_policy
    @content = SiteConfiguration.first.try(:cookies_content)
  end

  def about
  end
end
