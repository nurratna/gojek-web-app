class OrdersController < ApplicationController
  before_action :dont_accses, only: [:index, :destroy]
  before_action :authorize_user_login
  before_action :set_order, only: [:show, :destroy]

  def index
    @orders = Order.all
  end

  def show
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    @order.user = User.find(session[:user_id])

    respond_to do |format|
      if @order.save
        if @order.status == "Completed"
          driver = Driver.find(@order.driver_id)
          format.html { redirect_to @order, notice: "Thank you for your order. Your driver is #{driver.name}" }
          format.json { render :show, status: :created, location: @order }
          flash[:notice] = "Post successfully created"
        else
          format.html { redirect_to current_user, alert: 'Sorry, your driver is not found' }
          format.json { render json: @order.errors, status: :unprocessable_entity }
        end
      else
        format.html { render :new }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

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

    def dont_accses
      if logged_in_user? || logged_in_driver? || logout_driver || logout_driver
        redirect_to home_index_path, alert: 'Access Denied! You dont have permission.'
      end
    end

    def authorize_user_login
      if !User.find_by(id: current_user)
        redirect_to login_url, alert: 'Access Denied! Please Login.'
      end
    end

end
