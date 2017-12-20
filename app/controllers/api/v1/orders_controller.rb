class Api::V1::OrdersController < ApplicationController
	# protect_from_forgery with: :exception
	before_action :set_order, only: [:show, :update]
  # before_action :authenticate

  # GET
	def index
		@orders = Order.all
		render json: {status: 'SUCCESS', message: 'Loaded user', data: @orders }, status: :ok
  end

  # GET
  def show
  	render json: {status: 'SUCCESS', message: 'Loaded user', data: @order }, status: :ok
  end

  # POST
  def create
  	@order = Order.new(order_params)
    if @order.save
      render json: {status: 'SUCCESS', message: 'Saved user', data: @order }, status: :ok
    else
      render json: {status: 'ERROR', message: 'Order not saved', data: @order.errors }, status: :unprocessable_entity
    end
  end

  # PATCH
  def update
    if @order.update(order_params)
      render json: {status: 'SUCCESS', message: 'Updated user', data: @order }, status: :ok
    else
      render json: {status: 'ERROR', message: 'Order not updated', data: @order.errors }, status: :unprocessable_entity
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:origin, :destination, :service_type, :payment_type)
    end

    def authenticate
      authenticate_or_request_with_http_basic do |email, password|
        user = Order.find_by_email(email)
        user && user.password == passsword_confirmation
      end
    end
end
