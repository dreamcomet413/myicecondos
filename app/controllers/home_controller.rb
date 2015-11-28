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

  def sell_with_us
    @page_title = "Sell With Us"
  end

  def location
    @page_title = "Location"
  end

  def reviews
    @page_title = "Reviews"
    @reviews = [
      ["chester.png", "It was a pleasure to work with Martin on the sale of my property. I appreciated his professionalism and the valuable advice that he provided throughout the sale process. In the end, Martin was able to bring me two offers within one week of listing, and my property sold for over the asking price. Well done!", "Chester C."],
      ["kimberly.png", "As a first time home buyer, I was apprehensive in working with an agent, as I wanted to find someone I could fully trust; with the biggest purchase of my life. I had spoken to multiple agents prior to meeting with Martin, and due to his informative and approachable demeanor, he immediately had me at ease. He was quick to understand my needs, responsive when handling my inquiries and delicately balanced professionalism with a genuine, effective approach when corresponding, scheduling showings and closing the sale. I can honestly say that it was a seamless transition into owning my first home, and I can’t thank Martin enough for all of his efforts in meeting tight deadlines and finding me a beautiful property!", "Kimberley W."],
      ["dr.png", "Martin is a great guy and a true professional at what he does. Would definitely recommend!", "Dr. Arsalan P."],
      ["stuart.png", "I gave Martin a list of requirements, then changed them three times on him and he didn’t bat an eye. He rolled with the punches and gracefully delivered results. From time of contact to closing on my new condo (28 days!) he got the job done. First time I’ve worked with an agent and felt like they were actually working for me and my interests! Martin has earned a client for life in me, I haven’t been more pleased with any service.", "Stuart S."],
      ["mary.png", "Martin was professional and successful in giving real estate advice to my husband and me. His wise and calm advice was much appreciated. We recommend him highly.", "Mary P."],
      ["devan.png", "You have been instrumental in my condo experiences. Both highly professional and knowledgeable in your field, I wouldn’t have anyone else in my corner when buying or selling a condo.  In my case it was one week from telling you that I needed my place on the market, to having it sold.  The condo was on the market for less than 72 hours and you helped me get more than I was expecting.  You are the definitive resource on how to present a condo and negotiate for top dollar.  You have been a pleasure to work with and I look forward to using you to purchase in the future.", "Devan T."],
      ["curtis.png", "Martin, you came to us highly recommended and you certainly lived up to your reputation. Throught the sale of our condo and the purchase of our home, you were an invaluable asset.  You provided us with excellent service through each step of the process; staging tips, pricing strategies, honest advice, superb negotiations, and poignant insight when we most needed it.  You excel as an agent becuase of your in-depth knowledge and understanding of the markets, your razor sharp negotiating sills, and your honest/professional approach.  We always felt that you had our best interest in mind and go us the best deals possible for both transactions.  We will always recommend you to family and friends because you treated as like family.  Thank you Martin!", "Curtis and Rachel"],
      ["chester.png", "Record Breaking sale - Thanks to Martin!!! With warm appreciation for all you’ve given of your time, your energy and yourself.   We were so fortunate to have met you", "Alina & Howard Mc."],
      ["kimberly.png", "Dear Martin, Professionalism, service, friendliness, patience, and courtesy all describe you in the way you handled the purchase of my first property.  I couldn’t ask for any more from a real estate agent! You will be HIGHLY RECOMMENDED by me to anyone looking to buy or sell! Thank you for all your help!", "Thomas L."]
    ]
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
