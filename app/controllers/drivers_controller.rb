class DriversController < ApplicationController
  before_action :authorized_driver, except: [:new, :create]
  before_action :authorized_current_driver, only: [:show, :edit, :update, :destroy, :topup, :save_topup, :location, :update_location]
  before_action :authorized_current_driver_permission, only: [:index, :new, :create]
  before_action :set_driver, only: [:show, :edit, :update, :destroy, :topup, :save_topup, :location, :update_location]

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
        @driver.token
        @driver.regenerate_token
        login_driver @driver
        format.html { redirect_to @driver, notice: "Welcome #{@driver.name.upcase}. Your Location default is Jakarta" }
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
        format.html { redirect_to @driver, notice: 'Driver was successfully updated.' }
        format.json { render :show, status: :ok, location: @driver }
      else
        format.html { render :edit }
        format.json { render json: @driver.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /drivers/1
  # DELETE /drivers/1.json
  def destroy
    @driver.destroy
    respond_to do |format|
      format.html { redirect_to drivers_url, notice: 'Driver was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # GET /driver/1/topup
  def topup
  end

  # PATCH /drivers/1/topup
  def save_topup
    respond_to do |format|
      if @driver.topup(params[:topup_gopay])
        format.html { redirect_to drivers_url, notice: "Go Pay was successfully updated" }
        format.json { render :show, status: :ok, location: @driver }
      else
        format.html { render :topup }
        format.json { render json: @driver.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /driver/1/location
  def location
  end

  # PATCH /drivers/1/location
  def update_location
    respond_to do |format|
      if @driver.loc(params[:location])
        format.html { redirect_to drivers_url, notice: "Location was successfully updated" }
        format.json { render :show, status: :ok, location: @driver }
      else
        format.html { render :location }
        format.json { render json: @driver.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_driver
      @driver = Driver.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def driver_params
      params.require(:driver).permit(:name, :email, :phone, :location, :password, :password_confirmation)
    end

    def authorized_driver
      if !Driver.find_by(id: session[:driver_id])
        redirect_to login_url, alert: 'Access Denied! Please Login'
      end
    end

    def authorized_current_driver
      driver = Driver.find(params[:id])
      if driver != current_driver
        redirect_to current_driver, alert: "Access Denied! You don't have permission"
      end
    end

    def authorized_current_driver_permission
      if !session[:driver_id].nil?
        redirect_to current_driver, alert: "Access Denied! You don't have permission"
      end
    end
end
