class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:terms, :change_password, :user_from_crm]

  skip_before_filter :verify_authenticity_token, only: [:change_password, :user_from_crm]

  def my_profile
    @page_title = "My Account"
  end

  def update
    current_user.update_attributes(user_params)
    redirect_to my_account_path, notice: "Saved successfully"
  end

  def subscriptions
  end

  def update_subscriptions
    current_user.update_attributes(user_params)
    redirect_to subscriptions_path, notice: "Saved successfully"
  end

  def terms
  end

  def change_password
    u = User.where(email: params[:email]).first
    render nothing: true unless u
    u.update_attributes(password: params[:new_password], password_confirmation: params[:new_password]) if params[:token] == APP_CONFIG[:crm_call_token]
    render nothing: true
  end

  def user_from_crm
    render nothing: true unless params[:token] == APP_CONFIG[:crm_call_token]
    u = User.where(email: params[:new_user][:email]).first_or_initialize
    u.assign_attributes params.require(:new_user).permit!
    u.save!
    render nothing: true
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :address, :city, :province, :country, :postal_code, :phone_number, :newsletter_subscribed, :unsubscribe_all, :avatar)
  end
end
