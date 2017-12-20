class ApplicationController < ActionController::Base
  include SessionsHelper
  protect_from_forgery with: :exception
  # before_action :authorize

  protected
    def authorize
      if !User.find_by(id: session[:user_id])
        redirect_to login_url, alert: 'Access Denied! Please Login'
      end
    end
end
