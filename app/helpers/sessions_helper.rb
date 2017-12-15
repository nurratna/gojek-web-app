module SessionsHelper
  def login_user(user)
    session[:user_id] = user.id
    session[:role] = 'user'
  end

  def login_driver(driver)
    session[:driver_id] = driver.id
    session[:role] = 'driver'
  end

  def logout_user
    session.delete(:user_id)
    session.delete(:role)
  end

  def logout_driver
    session.delete(:driver_id)
    session.delete(:role)
  end
end
