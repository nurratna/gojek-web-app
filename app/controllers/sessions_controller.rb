class SessionsController < ApplicationController
  skip_before_action :authorize

  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user.try(:authenticate, params[:password])
      session[:user_id] = user.id
      redirect_to user_path, method: :get
      # if user.roles.find_by(name: 'administrator')
      #   redirect_to admin_url
      # else
      #   redirect_to store_index_url
      # end
    else
      redirect_to login_url, alert: 'Invalid email/password combination'
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to home_index_url, notice: 'Logged out'
  end
end
