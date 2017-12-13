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
  end

  context 'with origin lat-long not found' do
    it 'is invalid if lat-long not found' do
      order = build(:order, origin: "asdfxzcxc")
      order.valid?
      # expect(order).to eq(nil)
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

end
