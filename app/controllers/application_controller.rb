class ApplicationController < ActionController::Base
  include SessionsHelper

  protect_from_forgery with: :exception
  before_action :authorize_user
  # before_action :authorize_driver

  protected
    def authorize_user
      unless User.find_by(id: session[:user_id])
        redirect_to login_url, alert: 'Access Denied! Please Login'
      end
    end

    # def authorize_driver
    #   unless Driver.find_by(id: session[:driver_id])
    #     redirect_to login_url, notice: 'Please Login'
    #   end
    # end
end
