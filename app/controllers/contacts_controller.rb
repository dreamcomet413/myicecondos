class ContactsController < ApplicationController
  def new
    @title = "Contact Us"
    @content = SiteConfiguration.first.try(:contact_content)
    @contact = Contact.new
  end

  def create
    @title = "Contact Us"
    @content = SiteConfiguration.first.try(:contact_content)
    @contact = Contact.new(params[:contact])
    @contact.request = request
    if @contact.deliver
      flash.now[:notice] = 'Thank you for your message. We will contact you soon!'
      redirect_to contact_path
    else
      flash.now[:error] = 'Cannot send message.'
      render :new
    end
  end
end
