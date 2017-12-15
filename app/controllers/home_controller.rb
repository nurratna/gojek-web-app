class HomeController < ApplicationController
  skip_before_action :authorize_user
  # skip_before_action :authorize_driver

  def index
  end
end
