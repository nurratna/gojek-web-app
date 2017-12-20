class DriversController < ApplicationController
  before_action :authorize_login, except: [:new, :create]
  before_action :authorize_logout, only: [:index, :new, :create]
  before_action :authorized_current_driver, only: [:show, :edit, :update, :destroy, :gopay, :location, :current_location, :job]
  before_action :set_driver, only: [:show, :edit, :update, :destroy, :gopay, :location, :current_location]

  # GET /drivers
  # GET /drivers.json
  def index
    @drivers = Driver.all
  end

  # GET /drivers/1
  # GET /drivers/1.json
  def show
  end

  # GET /drivers/new
  def new
    @driver = Driver.new
  end

  # GET /drivers/1/edit
  def edit
  end

  # POST /drivers
  # POST /drivers.json
  def create
    @driver = Driver.new(driver_params)
    respond_to do |format|
      if @driver.save
        login_driver @driver
        format.html { redirect_to @driver, notice: "Welcome #{@driver.name.upcase}. Your account was successfully created" }
        format.json { render :show, status: :created, location: @driver }
      else
        format.html { render :new }
        format.json { render json: @driver.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /drivers/1
  # PATCH/PUT /drivers/1.json
  def update
    respond_to do |format|
      if @driver.update(driver_params)
        # @driver.set_location_goride(params[:location])
        format.html { redirect_to @driver, notice: 'Driver was successfully updated.' }
        format.json { render :show, status: :ok, location: @driver }
      else
        format.html { render :edit }
        format.json { render json: @driver.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /driver/1/gopay
  def gopay
  end

  # GET /driver/1/location
  def location
  end

  # PATCH /drivers/1/location
  def current_location
    respond_to do |format|
      if @driver.loc(params[:location])
        format.html { redirect_to @driver, notice: "Location was successfully updated" }
        format.json { render :show, status: :ok, location: @driver }
      else
        format.html { render :location }
        format.json { render json: @driver.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /users/1/order
  def job
    # @orders = Order.where(driver_id: current_driver)
    @orders = Order.where(driver_id: current_driver).paginate(:page => params[:page], :per_page => 5).order('created_at DESC')

  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_driver
      @driver = Driver.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def driver_params
      params.require(:driver).permit(:name, :email, :phone, :location, :service_type, :password, :password_confirmation)
    end

    def authorize_login
      if !Driver.find_by(id: current_driver)
        redirect_to login_url, alert: 'Access Denied! Please Login'
      end
    end

    def authorize_logout
      if logged_in_driver?
        redirect_to current_driver, alert: "Access Denied! You don't have permission"
      end
    end

    def authorized_current_driver
      driver = Driver.find(params[:id])
      if driver != current_driver
        redirect_to current_driver, alert: "Access Denied! You don't have permission"
      end
    end
end
