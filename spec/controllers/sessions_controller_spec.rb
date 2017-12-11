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
    end

    context "with valid username and password" do
      it "assigns user_id to session variables" do
        post :create, params: { email: 'user@gmail.com', password: 'longpassword' }
        expect(session[:user_id]).to eq(@user.id)
      end

      it "redirects to user index page" do
        post :create, params: { email: 'user@gmail.com', password: 'longpassword' }
        expect(response).to redirect_to users_url
      end
    end

    context "with invalid username and password" do
      it "redirects to login page" do
        post :create, params: { email: 'user@gmail.com', password: 'wrongpassword' }
        expect(response).to redirect_to login_url
      end
    end
  end

  describe "DELETE destroy" do
    before :each do
      @user = create(:user)
    end

    it "removes user_id from session variables" do
      delete :destroy, params: { id: @user }
      expect(session[:user_id]).to eq(nil)
    end

    it "redirects to store index page" do
      delete :destroy, params: { id: @user }
      expect(response).to redirect_to home_index_url
    end
  end
end
