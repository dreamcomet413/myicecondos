class ContactsController < ApplicationController
  layout 'contact'

  def new
    @page_title = "Contact Us"
    @content = SiteConfiguration.first.try(:contact_content)
    @contact = Contact.new
    session[:contact_referrer] = params[:u] if params[:u].present?
  end

  def new_condo_eval
    @page_title = "Condo Evaluation Form"
    @content = SiteConfiguration.first.try(:contact_content)
    @contact = CondoEvalForm.new
    session[:contact_referrer] = params[:u] if params[:u].present?
  end

  def create_condo_eval
    @page_title = "Condo Evaluation Form"
    @content = SiteConfiguration.first.try(:contact_content)
    @contact = CondoEvalForm.new(params[:condo_eval_form])
    @contact.request = request
    if @contact.deliver
      flash[:notice] = 'Thank you for your message. We will contact you soon!'
      redirect_to condo_eval_form_path
    else
      flash.now[:error] = 'Cannot send message.'
      render :new_condo_eval
    end
  end

  def create
    @page_title = "Contact Us"
    @content = SiteConfiguration.first.try(:contact_content)
    @contact = Contact.new(params[:contact])
    @contact.request = request

    if @contact.deliver
      flash[:notice] = 'Thank you for your message. We will contact you soon!'
      redirect_to contact_path
    else
      flash.now[:error] = 'Cannot send message.'
      render :new
    end
  end
end
