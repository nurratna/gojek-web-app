class Api::V1::LocationGocarsController < ApplicationController
	# protect_from_forgery with: :exception
	before_action :set_location_gocar, only: [:show, :update]
  # before_action :authenticate

  # GET
	def index
		@location_gocars = Location::Gocar.all
		render json: {status: 'SUCCESS', message: 'Loaded location_gocar', data: @location_gocars }, status: :ok
  end

  # GET
  def show
  	render json: {status: 'SUCCESS', message: 'Loaded location_gocar', data: @location_gocar }, status: :ok
  end

  # POST
  def create
  	@location_gocar = Location::Gocar.new(location_gocar_params)
    if @location_gocar.save
      render json: {status: 'SUCCESS', message: 'Saved location_gocar', data: @location_gocar }, status: :ok
    else
      render json: {status: 'ERROR', message: 'LocationGocar not saved', data: @location_gocar.errors }, status: :unprocessable_entity
    end
  end

  # PATCH
  def update
    if @location_gocar.update(location_gocar_params)
      render json: {status: 'SUCCESS', message: 'Updated location_gocar', data: @location_gocar }, status: :ok
    else
      render json: {status: 'ERROR', message: 'LocationGocar not updated', data: @location_gocar.errors }, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location_gocar
      @location_gocar = Location::Gocar.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def location_gocar_params
      params.require(:location_gocar).permit(:name, :email, :phone, :password, :passsword_confirmation)
    end

    def authenticate
      authenticate_or_request_with_http_basic do |email, password|
        location_gocar = Location::Gocar.find_by_email(email)
        location_gocar && location_gocar.password == passsword_confirmation
      end
    end
end
