module SessionsHelper
  # Logs in the given user.
  def login_user(user)
    session[:user_id] = user.id
    session[:role] = 'user'
  end

  def login_driver(driver)
    session[:driver_id] = driver.id
    session[:role] = 'driver'
  end

  # Returns the current logged-in user (if any).
  def current_user
    if @current_user.nil?
      @current_user = User.find_by(id: session[:user_id])
    else
      @current_user
    end
  end

  def current_driver
    if @current_driver.nil?
      @current_driver = Driver.find_by(id: session[:driver_id])
    else
      @current_driver
    end
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in_user?
    !current_user.nil?
  end

  def logged_in_driver?
    !current_driver.nil?
  end

  def logout_user
    session.delete(:user_id)
    session.delete(:role)
    @current_user = nil
  end

  def logout_driver
    session.delete(:driver_id)
    session.delete(:role)
    @current_driver = nil
  end
end
