require 'rails_helper'

describe SessionsController do
  include SessionsHelper

  describe "GET new" do
    context 'with logged in' do
      it "redirects to user#show if user logged in" do
        user = create(:user, email: 'user@gmail.com', password: 'longpassword', password_confirmation: 'longpassword')
        login_user(user)
        get :new
        expect(response).to redirect_to current_user
      end

      it "redirects to driver#show if driver logged in" do
        driver = create(:driver, email: 'driver@gmail.com', password: 'longpassword', password_confirmation: 'longpassword')
        login_driver(driver)
        get :new
        expect(response).to redirect_to current_driver
      end
    end

    context 'with logged out' do
      it "renders the :new template" do
        logout_user
        logout_driver
        get :new
        expect(response).to render_template :new
      end
    end
  end

  describe "POST create" do
    before :each do
      @user = create(:user, email: 'user@gmail.com', password: 'longpassword', password_confirmation: 'longpassword')
      @driver = create(:driver, email: 'driver@gmail.com', password: 'longpassword', password_confirmation: 'longpassword')
    end

    context "with user Logged in" do
      context "with valid username and password" do
        it "assigns user_id to session variables" do
          post :create, params: { email: 'user@gmail.com', password: 'longpassword' }
          login_user(@user)
          expect(session[:user_id]).to eq(@user.id)
        end

        it "assigns role to session variables" do
          post :create, params: { email: 'user@gmail.com', password: 'longpassword' }
          login_user(@user)
          expect(session[:role]).to eq('user')
        end

        it "redirects to login page" do
          post :create, params: { email: 'user@gmail.com', password: 'longpassword' }
          expect(response).to redirect_to login_url
        end
      end

      context "with invalid username and password" do
        it "redirects to login page" do
          post :create, params: { email: 'user@gmail.com', password: 'wrongpassword' }
          expect(response).to redirect_to login_path
        end
      end
    end

    context "with driver Logged in" do
      context "with valid username and password" do
        it "assigns driver_id to session variables" do
          post :create, params: { email: 'driver@gmail.com', password: 'longpassword' }
          login_driver(@driver)
          expect(session[:driver_id]).to eq(@driver.id)
        end

        it "assigns role to session variables" do
          post :create, params: { email: 'driver@gmail.com', password: 'longpassword' }
          login_driver(@driver)
          expect(session[:role]).to eq('driver')
        end

        it "redirects to login page" do
          post :create, params: { email: 'driver@gmail.com', password: 'longpassword' }
          expect(response).to redirect_to login_url
        end
      end

      context "with invalid username and password" do
        it "redirects to login page" do
          post :create, params: { email: 'driver@gmail.com', password: 'wrongpassword' }
          expect(response).to redirect_to login_path
        end
      end
    end
  end

  describe "DELETE destroy" do
    before :each do
      @user = create(:user)
    end

    context "with user Logged out" do
      it "removes user_id from session variables" do
        delete :destroy, params: { id: @user }
        expect(session[:user_id]).to eq(nil)
      end

      it "removes role from session variables" do
        delete :destroy, params: { id: @user }
        expect(session[:role]).to eq(nil)
      end

      it "redirects to store index page" do
        delete :destroy, params: { id: @user }
        expect(response).to redirect_to home_index_url
      end
    end

    context "with driver Logged out" do
      it "removes driver_id from session variables" do
        delete :destroy, params: { id: @driver }
        expect(session[:driver_id]).to eq(nil)
      end

      it "removes role from session variables" do
        delete :destroy, params: { id: @user }
        expect(session[:role]).to eq(nil)
      end

      it "redirects to store index page" do
        delete :destroy, params: { id: @driver }
        expect(response).to redirect_to home_index_url
      end
    end
  end
end
