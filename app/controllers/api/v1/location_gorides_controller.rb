class Api::V1::LocationGoridesController < ApplicationController
	# protect_from_forgery with: :exception
	before_action :set_location_goride, only: [:show, :update]
  # before_action :authenticate

  # GET
	def index
		@location_gorides = Location::Goride.all
		render json: {status: 'SUCCESS', message: 'Loaded location_goride', data: @location_gorides }, status: :ok
  end

  # GET
  def show
  	render json: {status: 'SUCCESS', message: 'Loaded location_goride', data: @location_goride }, status: :ok
  end

  # POST
  def create
  	@location_goride = Location::Goride.new(location_goride_params)
    if @location_goride.save
      render json: {status: 'SUCCESS', message: 'Saved location_goride', data: @location_goride }, status: :ok
    else
      render json: {status: 'ERROR', message: 'LocationGoride not saved', data: @location_goride.errors }, status: :unprocessable_entity
    end
  end

  # PATCH
  def update
    if @location_goride.update(location_goride_params)
      render json: {status: 'SUCCESS', message: 'Updated location_goride', data: @location_goride }, status: :ok
    else
      render json: {status: 'ERROR', message: 'LocationGoride not updated', data: @location_goride.errors }, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_location_goride
      @location_goride = Location::Goride.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def location_goride_params
      params.require(:location_goride).permit(:name, :email, :phone, :password, :passsword_confirmation)
    end

    def authenticate
      authenticate_or_request_with_http_basic do |email, password|
        location_goride = Location::Goride.find_by_email(email)
        location_goride && location_goride.password == passsword_confirmation
      end
    end
end
