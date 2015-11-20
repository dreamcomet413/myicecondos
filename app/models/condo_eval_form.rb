class CondoEvalForm < MailForm::Base
  attribute :first_name,      :validate => true
  attribute :last_name,      :validate => true
  attribute :email,     :validate => /\A([\w\.%\+\-]+)@([\w\-]+\.)+([\w]{2,})\z/i
  attribute :phone
  attribute :message
  attribute :building,      :validate => true
  attribute :unit,      :validate => true
  attribute :time_frame,      :validate => true
  attributes :nickname,   :captcha => true

  # Declare the e-mail headers. It accepts anything the mail method
  # in ActionMailer accepts.
  def headers
    {
      :subject => "Ice Condos: Condo Evaluation Form",
      :to => "#{SiteConfiguration.first.try(:contact_us_email)}",
      :from => %("#{first_name} #{last_name}" <#{email}>)
    }
  end
end
