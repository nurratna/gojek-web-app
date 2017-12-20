class UsersController < ApplicationController
  before_action :authorize_login, except: [:new, :create]
  before_action :authorize_logout, only: [:index, :new, :create]
  before_action :authorized_current_user, only: [:show, :edit, :update, :destroy, :topup, :save_topup, :order]
  before_action :set_user, only: [:show, :edit, :update, :destroy, :topup, :save_topup]

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
  end

  # GET users/new
  def new
    @user = User.new
  end

  # GET /users/edit
  def edit
  end

  # POST /users
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        login_user @user
        format.html { redirect_to @user, notice: "Welcome #{@user.name.upcase}. Your account was successfully created."}
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.'}
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroy" }
      format.json { head :no_content }
    end
  end

  # GET /user/1/topup
  def topup
  end

  # PATCH /users/1/topup
  def save_topup
    respond_to do |format|
      if @user.topup(params[:topup_gopay])
        format.html { redirect_to @user, notice: "Go Pay was successfully updated" }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :topup }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /users/1/order
  def order
    # @orders = Order.where(user_id: current_user)
    @orders = Order.where("user_id = ? AND status = ?", current_user, 1)
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :phone, :password, :passsword_confirmation)
    end

    def authorize_login
      if !User.find_by(id: current_user)
        redirect_to login_url, alert: 'Access Denied! Please Login'
      end
    end

    def authorize_logout
      if logged_in_user?
        redirect_to current_user, alert: "Access Denied! You don't have permission"
      end
    end

    def authorized_current_user
      @user = User.find(params[:id])
      if @user != current_user
        redirect_to current_user, alert: "Access Denied! You don't have permission"
      end
    end

    def authenticate
      authenticate_or_request_with_http_basic do |source_app, api_key|
        client = Client.find_by_source_app(source_app)
        client && client.api_key == api_key
      end
    end
end
