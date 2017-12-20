class Api::V1::UsersController < ApplicationController
	# protect_from_forgery with: :exception
	before_action :set_user, only: [:show, :update]
  # before_action :authenticate

  # GET
	def index
		@users = User.all
		render json: {status: 'SUCCESS', message: 'Loaded user', data: @users }, status: :ok
  end

  # GET
  def show
  	render json: {status: 'SUCCESS', message: 'Loaded user', data: @user }, status: :ok
  end

  # POST
  def create
  	@user = User.new(user_params)
    if @user.save
      render json: {status: 'SUCCESS', message: 'Saved user', data: @user }, status: :ok
    else
      render json: {status: 'ERROR', message: 'User not saved', data: @user.errors }, status: :unprocessable_entity
    end
  end

  # PATCH
  def update
    if @user.update(user_params)
      render json: {status: 'SUCCESS', message: 'Updated user', data: @user }, status: :ok
    else
      render json: {status: 'ERROR', message: 'User not updated', data: @user.errors }, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :phone, :password, :passsword_confirmation)
    end

    def authenticate
      authenticate_or_request_with_http_basic do |email, password|
        user = User.find_by_email(email)
        user && user.password == passsword_confirmation
      end
    end
end
