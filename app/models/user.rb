class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  acts_as_messageable

  before_create :set_faye_token

  after_save :send_to_crm

  has_many :favourites
  has_many :prospect_matches
  has_many :ahoy_events, :foreign_key => 'user_id', :class_name => "Ahoy::Event"

  has_attached_file :avatar, :default_url => "http://icecondos.s3.amazonaws.com/default_avatar.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  def name
    "#{first_name} #{last_name}"
  end

  def mailboxer_email(object)
    nil
  end

  def favourited?(listing_id)
    favourites.where(favouriteable_id: listing_id).present?
  end

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = User.where(:provider => auth.provider, :uid => auth.uid).first
    if user
      return user
    else
      registered_user = User.where(:email => auth.info.email).first
      if registered_user
        return registered_user
      else
        img = URI.parse(auth.info.image.gsub("http://", "https://")) if auth.info.image.present?
        user = User.create( provider:auth.provider,
                            uid:auth.uid,
                            email:auth.info.email,
                            password:Devise.friendly_token[0,20],
                            avatar: img,
                            first_name: auth.info.first_name,
                            last_name: auth.info.last_name
                          )
      end

    end
  end

  def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
      data = access_token.info
      user = User.where(:provider => access_token.provider, :uid => access_token.uid ).first
      if user
        return user
      else
        registered_user = User.where(:email => access_token.info.email).first
        if registered_user
          return registered_user
        else
          img = URI.parse(data["image"].gsub("http://", "https://")) if data["image"].present?
          user = User.create(
            provider:access_token.provider,
            email: data["email"],
            uid: access_token.uid ,
            password: Devise.friendly_token[0,20],
            avatar: img,
            first_name: data["first_name"],
            last_name: data["last_name"]
          )
        end
     end
  end

  private

  def set_faye_token
    return if faye_token.present?
    self.faye_token = generate_faye_token
  end

  def generate_faye_token
    loop do
      token = SecureRandom.hex(16)
      break token unless self.class.exists?(faye_token: token)
    end
  end

  def send_to_crm
    user_location = Geocoder.search(last_sign_in_ip).first
    lead_params = {
      user: true,
      first_name: first_name,
      last_name: last_name,
      email: email,
      phone: phone_number,
      source: "Registration",
      lat: user_location.try(:latitude),
      long: user_location.try(:longitude),
      address: {
        street1: address,
        city: city,
        state: province,
        country: country,
        zipcode: postal_code,
        address_type: "Business"
      }
    }
    Crm::Lead.delay(priority: 10).send_to_crm lead_params
  end
end
