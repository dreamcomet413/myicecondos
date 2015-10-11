class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :configure_permitted_parameters, if: :devise_controller?

  helper_method :logged_in?

  def logged_in?
    user_signed_in?
  end

  def after_sign_in_path_for(resource)
    if request.referer.include?("/listings")
      request.referer.include?("?") ? "#{request.referer}&map=true" : "#{request.referer}?map=true"
    else
      root_path
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:first_name, :last_name, :password, :password_confirmation, :current_password]
  end

end