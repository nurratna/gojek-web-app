class Api::V1::DriversController < ApplicationController
	# protect_from_forgery with: :exception
	before_action :set_driver, only: [:show, :update]
  # before_action :authenticate

  # GET
	def index
		@drivers = Driver.all
		render json: {status: 'SUCCESS', message: 'Loaded user', data: @drivers }, status: :ok
  end

  # GET
  def show
  	render json: {status: 'SUCCESS', message: 'Loaded user', data: @driver }, status: :ok
  end

  # POST
  def create
  	@driver = Driver.new(driver_params)
    if @driver.save
      render json: {status: 'SUCCESS', message: 'Saved user', data: @driver }, status: :ok
    else
      render json: {status: 'ERROR', message: 'Driver not saved', data: @driver.errors }, status: :unprocessable_entity
    end
  end

  # PATCH
  def update
    if @driver.update(driver_params)
      render json: {status: 'SUCCESS', message: 'Updated user', data: @driver }, status: :ok
    else
      render json: {status: 'ERROR', message: 'Driver not updated', data: @driver.errors }, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_driver
      @driver = Driver.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def driver_params
      params.require(:user).permit(:name, :email, :phone, :password, :passsword_confirmation)
    end

    def authenticate
      authenticate_or_request_with_http_basic do |email, password|
        user = Driver.find_by_email(email)
        user && user.password == passsword_confirmation
      end
    end
end
