require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  include SessionsHelper

  before :each do
    @user = create(:user)
    login_user(@user)
  end

  describe "GET #index" do
    context 'user logged in' do
      it 'redirects to user#show' do
        get :index
        expect(response).to redirect_to current_user
      end
    end

    context 'user logged out' do
      it 'redirects to login page' do
        logout_user
        get :index
        expect(response).to redirect_to login_url
      end
    end
  end

  describe 'GET #show' do
    context 'user logged in' do
      it 'assigns the requested current user to @user' do
        get :show, params: { id: @user }
        expect(assigns(:user)).to eq(@user)
      end

      it 'renders the :show template' do
        get :show, params: { id: @user }
        expect(response).to render_template(:show)
      end

      it "redirects to current user#show if requested other user" do
        user = create(:user)
        get :show, params: { id: user }
        expect(response).to redirect_to current_user
      end
    end

    context 'user logged out' do
      it 'redirects to login page' do
        logout_user
        get :show, params: { id: @user }
        expect(response).to redirect_to login_url
      end
    end
  end

  describe 'GET #new' do
    context "user logged in" do
      it 'does not assigns a new User to @user' do
        get :new
        expect(assigns(:user)).not_to be_a_new(User)
      end

      it 'redirects to user#show' do
        get :new
        expect(response).to redirect_to current_user
      end
    end

    context "user logged out" do
      it 'assigns a new User to @user' do
        logout_user
        get :new
        expect(assigns(:user)).to be_a_new(User)
      end

      it 'renders the :new template' do
        logout_user
        get :new
        expect(response).to render_template(:new)
      end
    end
  end

  describe 'GET #edit' do
    context 'user logged in' do
      it "assigns the requested user to @user" do
        get :edit, params: { id: @user }
        expect(assigns(:user)).to eq @user
      end

      it "renders the :edit template" do
        get :edit, params: { id: @user }
        expect(response).to render_template :edit
      end

      it "redirects to current user#show if requested other user" do
        user = create(:user)
        get :edit, params: { id: user }
        expect(response).to redirect_to current_user
      end
    end

    context 'user logged out' do
      it 'redirects to login page' do
        logout_user
        get :edit, params: { id: @user }
        expect(response).to redirect_to login_url
      end
    end
  end

  describe 'POST #create' do
    context 'user logged in' do
      it "does not saves the new user in the database" do
        expect{
          post :create, params: { user: attributes_for(:user) }
        }.not_to change(User, :count)
      end

      it "redirects to user#show" do
        post :create, params: { user: attributes_for(:user) }
        expect(response).to redirect_to current_user
      end
    end

    context 'user logged out' do
      before :each do
        logout_user
      end

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
  end

  describe 'PATCH #update' do
    context 'user logged in' do
      before :each do
        @user = create(:user, password: 'oldpassword', password_confirmation: 'oldpassword')
        login_user(@user)
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

    context 'user logged out' do
      it 'redirects to login page' do
        logout_user
        patch :update, params: { id: @user, user: attributes_for(:user) }
        expect(response).to redirect_to login_url
      end
    end
  end

  describe 'GET #topup' do
    context 'user logged in' do
      it 'assigns the requested topup to user' do
        get :topup, params: { id: @user}
        expect(assigns(:user)).to eq(@user)
      end

      it "renders the :topup template" do
        get :topup, params: { id: @user }
        expect(response).to render_template(:topup)
      end

      it "redirects to current user#show if requested topup other user" do
        user = create(:user)
        get :topup, params: { id: user }
        expect(response).to redirect_to current_user
      end
    end

    context 'user logged out' do
      it 'redirects to login page' do
        logout_user
        get :topup, params: { id: @user }
        expect(response).to redirect_to login_url
      end
    end
  end

  describe "PATCH #save_topup" do
    context 'user logged in' do
      before :each do
        @user = create(:user, gopay: 50000)
        login_user(@user)
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

    context 'user logged out' do
      it 'redirects to login page' do
        logout_user
        patch :save_topup, params: { id: @user, user: attributes_for(:user) }
        expect(response).to redirect_to login_url
      end
    end
  end
end
