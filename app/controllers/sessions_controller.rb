class SessionsController < ApplicationController
  before_action :ensure_logout, only: [:new, :create]

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    driver = Driver.find_by(email: params[:email])

    if params[:role] == 'user' && user.try(:authenticate, params[:password])
      login_user user
      redirect_to user
    elsif params[:role] == 'driver' && driver.try(:authenticate, params[:password])
      login_driver driver
      redirect_to driver
    elsif params[:role].blank?
      redirect_to login_url, alert: "Invalid Log In, Choose one of the role"
    else
      redirect_to login_url, alert: "Invalid email/password combination"
    end
  end

  def destroy
    if session[:user_id]
      logout_user
      redirect_to home_index_url, notice: 'Logged out'
    else
      logout_driver
      redirect_to home_index_url, notice: 'Logged out'
    end
  end

  private
    def ensure_logout
      if !session[:user_id].nil?
        redirect_to current_user, alert: 'Access Denied! You logged in'
      elsif !session[:driver_id].nil?
        redirect_to current_driver, alert: 'Access Denied! You logged in'
      end
    end
end
