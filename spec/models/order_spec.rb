require 'rails_helper'

RSpec.describe Order, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  it "has a valid factory" do
    expect(build(:order)).to be_valid
  end

  it "is valid with a origin, destination, service_type, payment_type" do
    expect(build(:order)).to be_valid
  end

  it "is invalid without origin" do
    order = build(:order, origin: nil)
    order.valid?
    expect(order.errors[:origin]).to include("can't be blank")
  end

  it "is invalid without destination" do
    order = build(:order, destination: nil)
    order.valid?
    expect(order.errors[:destination]).to include("can't be blank")
  end

  it "is invalid without service_type" do
    order = build(:order, service_type: nil)
    order.valid?
    expect(order.errors[:service_type]).to include("can't be blank")
  end

  it "is invalid without payment_type" do
    order = build(:order, payment_type: nil)
    order.valid?
    expect(order.errors[:payment_type]).to include("can't be blank")
  end

  it 'is invalid with wrong service_type' do
    expect{ build(:order, service_type: 'Go Food') }.to raise_error(ArgumentError)
  end

  it 'is invalid with wrong payment_type' do
    expect{ build(:order, payment_type: 'Grab Pay') }.to raise_error(ArgumentError)
  end

  context "with origin lat-long found" do
    it 'saves latitude/longitude if origin found' do
      order = build(:order, origin: 'kemang')
      order.save
      expect(order.origin_lat).not_to eq(nil)
    end

    it 'does not save if origin and destination have the same place' do
      order = build(:order, origin: 'kemang', destination: 'kemang')
      order.valid?
      expect(order.errors[:destination]).to include('must be different with Origin')
    end
  end

  context 'with origin lat-long not found' do
    it 'is invalid if lat-long not found' do
      order = build(:order, origin: "asdfxzcxc")
      order.valid?
      expect(order.errors[:origin]).to include("not found. Please check your connection or typo")
    end
  end

  context "with destination lat-long found" do
    it 'saves latitude/longitude if destination found' do
      order = build(:order, destination: 'kolla space sabang')
      order.save
      expect(order.destination_lat).not_to eq(nil)
    end

    it 'is invalid if distance > 25 km from origin' do
      order = build(:order, destination: 'Aceh')
      order.valid?
      expect(order.errors[:address]).to include("must not be more than 50 km away from origin")
    end
  end

  context 'with destination lat-long not found' do
    it 'is invalid if lat-long not found' do
      order = build(:order, destination: "asdfxzcxc")
      order.valid?
      expect(order.errors[:destination]).to include("not found. Please check your connection or typo")
    end
  end

  describe 'relations' do
    it { should belong_to(:user) }
    it { should belong_to(:driver) }
  end

  describe 'paying with gopay' do
    context "with sufficient gopay credit" do
      before :each do
        @user = create(:user, gopay: 150000)
      end

      it 'is valid with sufficient gopay credit' do
        order = build(:order, payment_type: 'Go Pay')
        order.user = @user
        expect(order).to be_valid
      end

      # it 'substracts user gopay credit with est_price if state is completed' do
      #   order = build(:order, payment_type: 'Go Pay', status: "Completed")
      #   order.calculate_est_price
      #   order.save
      #   expect(@user.gopay).to eq(150000 - order.calculate_est_price)
      # end

      it 'unsubstracts user gopay credit with est_price if state is cancel' do
        order = build(:order, payment_type: 'Go Pay', status: "Cancel")
        order.save
        expect(@user.gopay).to eq(150000)
      end
    end

    context 'with insufficient gopay credit' do
      before :each do
        @user = create(:user, gopay: 1000)
        @order = build(:order, payment_type: 'Go Pay')
        @order.user = @user
        @order.est_price = @order.calculate_est_price
      end

      it 'is invalid with insufficient gopay credit' do
        @order.valid?
        expect(@order.errors[:payment_type]).to include(": insufficient Go Pay credit")
      end

      it 'does not substracts user gopay' do
        expect(@order.user.gopay).not_to eq(0)
      end
    end
  end

  describe 'create order' do
    context 'driver found' do
      before :each do
        @driver = create(:driver, location: 'sarinah', service_type: 'Go Ride', gopay: 10000)
        @order = build(:order, origin: 'sarinah', destination: 'tanah abang', service_type: 'Go Ride', driver: @driver, status: 'Completed')
        @order.driver = @driver
        @order.est_price = @order.calculate_est_price
        @order.set_drivers
      end

      it "changes status to be completed" do
        expect(@order.status).to eq("Completed")
      end

      it "saves driver_id in order model" do
        expect(@order.driver_id).not_to eq(nil)
      end

      # it "changes location driver to destination" do
      #   expect(@order.driver.location).to eq("tanah abang")
      # end
      #
      # it "adds driver's gopay balance" do
      #   expect(@order.driver.gopay).to eq(10000 + @order.est_price)
      # end
    end

    context 'driver not found' do
      before :each do
        driver = create(:driver, location: 'bandung', service_type: 'Go Ride')
        @order = create(:order, origin: 'sarinah', destination: 'tanah abang', service_type: 'Go Ride', driver: driver)
        @order.set_drivers
      end

      it "changes status to be cancel" do
        expect(@order.status).to eq("Cancel")
      end

      it "does not save driver_id in order model" do
        expect(@order.driver_id).to eq(nil)
      end
    end
  end
end
