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
      expect(order.errors[:origin]).to include("not found")
    end
  end

  context "with destination lat-long found" do
    it 'saves latitude/longitude if destination found' do
      order = build(:order, destination: 'kolla space sabang')
      order.save
      expect(order.destination_lat).not_to eq(nil)
    end
  end

  context 'with destination lat-long not found' do
    it 'is invalid if lat-long not found' do
      order = build(:order, destination: "asdfxzcxc")
      order.valid?
      expect(order.errors[:destination]).to include("not found")
    end
  end

  describe 'relations' do
    it { should belong_to(:user) }
  end

  describe 'paying with gopay' do
    context "with sufficient gopay credit" do
      before :each do
        @user = create(:user, gopay: 150000)
        @order = build(:order, payment_type: 'Go Pay')
        @order.user = @user
      end

      it 'is valid with sufficient gopay credit' do
        expect(@order).to be_valid
      end

      it 'substracts user gopay credit with est_price' do
        @order.save
        expect(@user.gopay).to eq(150000 - @order.est_price)
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
end
