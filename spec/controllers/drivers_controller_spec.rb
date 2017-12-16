require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator.  If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails.  There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.
#
# Compared to earlier versions of this generator, there is very limited use of
# stubs and message expectations in this spec.  Stubs are only used when there
# is no simpler way to get a handle on the object needed for the example.
# Message expectations are only used when there is no simpler way to specify
# that an instance is receiving a specific message.

RSpec.describe DriversController, type: :controller do
  before :each do
    @driver = create(:driver)
    session[:driver_id] = @driver.id
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
    it 'assigns the requested driver to @driver' do
      driver = create(:driver)
      get :show, params: { id: driver }
      expect(assigns(:driver)).to eq(driver)
    end

    it 'renders the :show template' do
      driver = create(:driver)
      get :show, params: { id: driver }
      expect(response).to render_template(:show)
    end
  end

  describe 'GET #new' do
    it 'assigns a new driver to @driver' do
      get :new
      expect(assigns(:driver)).to be_a_new(Driver)
    end

    it 'renders the :new template' do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe 'GET #edit' do
    it "assigns the requested driver to @driver" do
      driver = create(:driver)
      get :edit, params: { id: driver }
      expect(assigns(:driver)).to eq driver
    end

    it "renders the :edit template" do
      driver = create(:driver)
      get :edit, params: { id: driver }
      expect(response).to render_template :edit
    end
  end

  describe 'POST #create' do
    context "with valid attributes" do
      it "saves the new driver in the database" do
        expect{
          post :create, params: { driver: attributes_for(:driver) }
        }.to change(Driver, :count).by(1)
      end

      it "redirects to drivers#index" do
        post :create, params: { driver: attributes_for(:driver) }
        expect(response).to redirect_to drivers_url
      end
    end

    context "with invalid attributes" do
      it "does not save the new driver in the database" do
        expect{
          post :create, params: { driver: attributes_for(:invalid_driver) }
        }.not_to change(Driver, :count)
      end

      it "re-renders the :new template" do
        post :create, params: { driver: attributes_for(:invalid_driver) }
        expect(response).to render_template :new
      end
    end
  end

  describe 'PATCH #update' do
    before :each do
      @driver = create(:driver, password: 'oldpassword', password_confirmation: 'oldpassword')
    end

    context "with valid attributes" do
      it "locates the requested @driver" do
        patch :update, params: { id: @driver, driver: attributes_for(:driver) }
        expect(assigns(:driver)).to eq(@driver)
      end

      it "saves new password" do
        patch :update, params: { id: @driver, driver: attributes_for(:driver, password: 'newlongpassword', password_confirmation: 'newlongpassword') }
        @driver.reload
        expect(@driver.authenticate('newlongpassword')).to eq(@driver)
      end

      it "redirects to drivers#index" do
        patch :update, params: { id: @driver, driver: attributes_for(:driver) }
        expect(response).to redirect_to @driver
      end

      it "disables login with old password" do
        patch :update, params: { id: @driver, driver: attributes_for(:driver, password: 'newlongpassword', password_confirmation: 'newlongpassword') }
        @driver.reload
        expect(@driver.authenticate('oldpassword')).to eq(false)
      end
    end

    context "with invalid attributes" do
      it "does not update the driver in the database" do
        patch :update, params: { id: @driver, driver: attributes_for(:driver, password: nil, password_confirmation: nil) }
        @driver.reload
        expect(@driver.authenticate(nil)).to eq(false)
      end

      it "re-renders the :edit template" do
        patch :update, params: { id: @driver, driver: attributes_for(:invalid_driver) }
        expect(response).to render_template :edit
      end
    end
  end

  describe 'GET #topup' do
    before :each do
      @driver = create(:driver)
    end

    it 'assigns the requested to driver' do
      get :topup, params: { id: @driver}
      expect(assigns(:driver)).to eq(@driver)
    end

    it "renders the :topup template" do
      get :topup, params: { id: @driver }
      expect(response).to render_template(:topup)
    end
  end

  describe "PATCH #save_topup" do
    before :each do
      @driver = create(:driver, gopay: 50000)
    end

    context "with valid attribut" do
      it "adds topup amount to driver's gopay in the database" do
        patch :save_topup, params: { id: @driver, driver: attributes_for(:driver), topup_gopay: 150000 }
        @driver.reload
        expect(@driver.gopay). to eq(200000)
      end

      it "redirect to the driver" do
        patch :save_topup, params: { id: @driver, driver: attributes_for(:driver), topup_gopay: 150000 }
        expect(response).to redirect_to(drivers_path)
      end
    end

    context "with invalid attribut" do
      it "does not change topup amount to driver's gopay in the database" do
        patch:save_topup, params: { id: @driver, driver: attributes_for(:driver), topup_gopay: -50000 }
        @driver.reload
        expect(@driver.gopay).not_to eq(0)
      end

      it "re-renders :topup template" do
        patch :save_topup, params: { id: @driver, driver: attributes_for(:driver), topup_gopay: -50000 }
        expect(response).to render_template(:topup)
      end
    end
  end

  describe 'GET #location' do
    before :each do
      @driver = create(:driver)
    end

    it 'assigns the requested to driver' do
      get :location, params: { id: @driver }
      expect(assigns(:driver)).to eq(@driver)
    end

    it "renders the :topup template" do
      get :location, params: { id: @driver }
      expect(response).to render_template(:location)
    end
  end

  describe "PATCH #update_location" do
    before :each do
      @driver = create(:driver, location: 'tanah abang')
    end

    context "with valid attribut" do
      it "adds location to driver's location in the database" do
        patch :update_location, params: { id: @driver, driver: attributes_for(:driver), location: 'kemang' }
        @driver.reload
        expect(@driver.location). to eq('kemang')
      end

      it "redirect to the driver" do
        patch :update_location, params: { id: @driver, driver: attributes_for(:driver), location: 'kemang' }
        expect(response).to redirect_to(drivers_path)
      end
    end

    context "with invalid attribut" do
      it "does not change location to driver's location in the database" do
        patch :update_location, params: { id: @driver, driver: attributes_for(:driver), location: 'ashdgat' }
        @driver.reload
        expect(@driver.location).not_to eq('kemang')
      end

      it "re-renders :location template" do
        patch :update_location, params: { id: @driver, driver: attributes_for(:driver), location: 'ashdgat' }
        expect(response).to render_template(:location)
      end
    end
  end
end
