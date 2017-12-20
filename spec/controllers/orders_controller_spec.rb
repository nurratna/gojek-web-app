require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  include SessionsHelper

  before :each do
    @user = create(:user)
    login_user @user
  end

  describe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET #show" do
    it "assigns to requested order to @order" do
      order = create(:order)
      get :show, params: { id: order }
      expect(assigns(:order)).to eq(order)
    end

    it "renders the :show template" do
      order = create(:order)
      get :show, params: { id: order }
      expect(response).to render_template(:show)
    end
  end

  describe "GET #new" do
    context "with user logged in" do
      it "assigns new order to @order" do
        get :new
        expect(assigns(:order)).to be_a_new(Order)
      end

      it "renders the :new template" do
        get :new
        expect(response).to render_template(:new)
      end
    end

    context "with user not logged in" do
      it "redirects to login page" do
        session[:user_id] = nil
        get :new
        expect(response).to redirect_to(login_url)
      end
    end
  end

  describe 'POST create' do
    context 'with valid attributes' do
      it 'saves the new order in the database' do
        expect {
          post :create, params: { order: attributes_for(:order, user_id: @user) }
        }.to change(Order, :count).by(1)
      end

      it 'redirects to order if logged in' do
        post :create, params: { order: attributes_for(:order, user_id: @user) }
        expect(response).to redirect_to(current_user)
      end
    end

    context 'with invalid attributes' do
      it 'does not save the new order in the database' do
        expect{
          post :create, params: { order: attributes_for(:invalid_order) }
        }.not_to change(Order, :count)
      end

      it 're-renders the :new template' do
        post :create, params: { order: attributes_for(:invalid_order) }
        expect(response).to render_template(:new)
      end
    end
  end
end
