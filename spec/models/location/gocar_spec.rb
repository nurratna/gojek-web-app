require 'rails_helper'

RSpec.describe Location::Gocar, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  it "has valid factory" do
    expect(build(:location_goride)).to be_valid
  end

  it "has a address" do
    expect(build(:location_goride)).to be_valid
  end

  it "is invalid without address" do
    location = build(:location_goride, address: nil)
    location.valid?
    expect(location.errors[:address]).to include("can't be blank")
  end

  it "is invalid with duplicate address" do
    location1 = create(:location_goride, address: "jakarta")
    location2 = build(:location_goride, address: "jakarta")
    location2.valid?
    expect(location2.errors[:address]).to include("has already been taken")
  end

  describe "relations" do
    it { should have_many(:drivers).with_foreign_key('location_gocar_id') }
  end
end
