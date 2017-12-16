class UsersController < ApplicationController
  before_action :authorized_user, except: [:new, :create]
  before_action :set_user, only: [:show, :edit, :update, :destroy, :topup, :save_topup]
  before_action :authorized_current_user, only: [:show, :edit, :update, :destroy, :topup, :save_topup]
  before_action :authorized_current_user_permission, only: [:index, :new, :create]

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
        @user.token
        @user.regenerate_token
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
        format.html { redirect_to users_url, notice: "Go Pay was successfully updated" }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :topup }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :phone, :password, :passsword_confirmation)
    end

    def authorized_user
      if !User.find_by(id: session[:user_id])
        redirect_to login_url, alert: 'Access Denied! Please Login'
      end
    end

    def authorized_current_user
      @user = User.find(params[:id])
      if @user != current_user
        redirect_to current_user, alert: "Access Denied! You don't have permission"
      end
    end

    def authorized_current_user_permission
      if !session[:user_id].nil?
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
