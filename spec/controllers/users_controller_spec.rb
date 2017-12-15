require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  before :each do
    @user = create(:user)
    session[:user_id] = @user.id
  end

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it 'renders the :index template' do
      get :index
      expect(response).to render_template(:index)
    end
  end

  describe 'GET #show' do
    it 'assigns the requested user to @user' do
      user = create(:user)
      get :show, params: { id: user }
      expect(assigns(:user)).to eq(user)
    end

    it 'renders the :show template' do
      user = create(:user)
      get :show, params: { id: user }
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    it 'assigns a new User to @user' do
      get :new
      expect(assigns(:user)).to be_a_new(User)
    end

    it 'renders the :new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'GET #edit' do
    it "assigns the requested user to @user" do
      user = create(:user)
      get :edit, params: { id: user }
      expect(assigns(:user)).to eq user
    end

    it "renders the :edit template" do
      user = create(:user)
      get :edit, params: { id: user }
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context "with valid attributes" do
      it "saves the new user in the database" do
        expect{
          post :create, params: { user: attributes_for(:user) }
        }.to change(User, :count).by(1)
      end

      it "redirects to user#show" do
        post :create, params: { user: attributes_for(:user) }
        expect(response).to redirect_to assigns[:user]
      end
    end

    context "with invalid attributes" do
      it "does not save the new user in the database" do
        expect{
          post :create, params: { user: attributes_for(:invalid_user) }
        }.not_to change(User, :count)
      end

      it "re-renders the :new template" do
        post :create, params: { user: attributes_for(:invalid_user) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before :each do
      @user = create(:user, password: 'oldpassword', password_confirmation: 'oldpassword')
    end

    context "with valid attributes" do
      it "locates the requested @user" do
        patch :update, params: { id: @user, user: attributes_for(:user) }
        expect(assigns(:user)).to eq(@user)
      end

      it "saves new password" do
        patch :update, params: { id: @user, user: attributes_for(:user, password: 'newlongpassword', password_confirmation: 'newlongpassword') }
        @user.reload
        expect(@user.authenticate('newlongpassword')).to eq(@user)
      end

      it "redirects to users#index" do
        patch :update, params: { id: @user, user: attributes_for(:user) }
        expect(response).to redirect_to @user
      end

      it "disables login with old password" do
        patch :update, params: { id: @user, user: attributes_for(:user, password: 'newlongpassword', password_confirmation: 'newlongpassword') }
        @user.reload
        expect(@user.authenticate('oldpassword')).to eq(false)
      end
    end

    context "with invalid attributes" do
      it "does not update the user in the database" do
        patch :update, params: { id: @user, user: attributes_for(:user, password: nil, password_confirmation: nil) }
        @user.reload
        expect(@user.authenticate(nil)).to eq(false)
      end

      it "re-renders the :edit template" do
        patch :update, params: { id: @user, user: attributes_for(:invalid_user) }
        expect(response).to render_template :edit
      end
    end
  end

  describe 'GET #topup' do
    before :each do
      @user = create(:user)
    end

    it 'assigns the requested to user' do
      get :topup, params: { id: @user}
      expect(assigns(:user)).to eq(@user)
    end

    it "renders the :topup template" do
      get :topup, params: { id: @user }
      expect(response).to render_template(:topup)
    end
  end

  describe "PATCH #save_topup" do
    before :each do
      @user = create(:user, gopay: 50000)
    end

    context "with valid attribut" do
      it "adds topup amount to user's gopay in the database" do
        patch :save_topup, params: { id: @user, user: attributes_for(:user), topup_gopay: 150000 }
        @user.reload
        expect(@user.gopay). to eq(200000)
      end

      it "redirect to the user" do
        patch :save_topup, params: { id: @user, user: attributes_for(:user), topup_gopay: 150000 }
        expect(response).to redirect_to(users_path)
      end
    end

    context "with invalid attribut" do
      it "does not change topup amount to user's gopay in the database" do
        patch:save_topup, params: { id: @user, user: attributes_for(:user), topup_gopay: -50000 }
        @user.reload
        expect(@user.gopay).not_to eq(0)
      end

      it "re-renders :topup template" do
        patch :save_topup, params: { id: @user, user: attributes_for(:user), topup_gopay: -50000 }
        expect(response).to render_template(:topup)
      end
    end
  end
end
