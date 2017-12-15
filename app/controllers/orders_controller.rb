class OrdersController < ApplicationController
  before_action :set_order, only: [:show, :destroy]
  # skip_before_action

  def index
    @orders = Order.all
  end

  def show
  end

  def new
    @order = Order.new
  end

  # def edit
  # end

  def create
    @order = Order.new(order_params)
    @order.user = User.find(session[:user_id])

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: 'Thank you for your order' }
        format.json { render :show, status: :created, location: @order }
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # def update
  # end

  def destroy
    @order.destroy
    respond_to do |format|
     format.html { redirect_to orders_path, notice: 'Order was successfully destroyed' }
     format.json { head :no_content}
    end
  end

  private
    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:origin, :destination, :service_type, :payment_type)
    end
end
