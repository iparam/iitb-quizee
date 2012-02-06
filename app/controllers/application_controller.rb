class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :store_location


  before_filter :authenticate_user!
  check_authorization :unless => :devise_controller?
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
  
  def store_location
    session[:user_return_to] = request.url unless params[:controller] == "devise/sessions"
    # If devise model is not User, then replace :user_return_to with :{your devise model}_return_to
  end

  def after_sign_in_path_for(resource)
    home_dashboard_path || root_path
  end
end
