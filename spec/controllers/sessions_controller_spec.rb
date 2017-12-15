require 'rails_helper'

describe SessionsController do
  describe "GET new" do
    it "renders the :new template" do
      get :new
      expect(:response).to render_template :new
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
          expect(session[:user_id]).to eq(@user.id)
        end

        it "assigns role to session variables" do
          post :create, params: { email: 'user@gmail.com', password: 'longpassword' }
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
          expect(session[:driver_id]).to eq(@driver.id)
        end

        it "assigns role to session variables" do
          post :create, params: { email: 'driver@gmail.com', password: 'longpassword' }
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
