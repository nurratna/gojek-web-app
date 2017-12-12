require 'rails_helper'

RSpec.describe User, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  it "has a valid factory" do
    expect(build(:user)).to be_valid
  end

  it "has a valid with name, email, phone, password and gopay" do
    expect(build(:user)).to be_valid
  end

  it "is invalid without a name" do
    user = build(:user, name: nil)
    user.valid?
    expect(user.errors[:name]).to include("can't be blank")
  end

  it "is invalid without a email" do
    user = build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  it "is invalid without a phone" do
    user = build(:user, phone: nil)
    user.valid?
    expect(user.errors[:phone]).to include("can't be blank")
  end

  it "is invalid with duplicate email" do
    user1 = create(:user, email: "nur@gmail.com")
    user2 = build(:user, email: "nur@gmail.com")
    user2.valid?
    expect(user2.errors[:email]).to include("has already been taken")
  end

  it "is invalid with duplicate phone number" do
    user1 = create(:user, phone: "085277206511")
    user2 = build(:user, phone: "085277206511")
    user2.valid?
    expect(user2.errors[:phone]).to include("has already been taken")
  end

  it 'is invalid with phone number not numeric' do
    user = build(:user, phone: '09-4748')
    user.valid?
    expect(user.errors[:phone]).to include('is not a number')
  end

  it 'is invalid with phone number length > 12' do
    user = build(:user, phone: '085277206511212')
    user.valid?
    expect(user.errors[:phone]).to include('is too long (maximum is 12 characters)')
  end

  context "on a new user" do
    it "is invalid without password" do
      user = build(:user, password: nil, password_confirmation: nil)
      user.valid?
      expect(user.errors[:password]).to include("can't be blank")
    end

    it "is invalid with less than 8 characters password" do
      user = build(:user,password: "asdf", password_confirmation: "asdf")
      user.valid?
      expect(user.errors[:password]).to include("is too short (minimum is 8 characters)")
    end

    it "is invalid with a confirmation mismatch" do
      user = build(:user, password: "longpassword", password_confirmation: "newlongpassword")
      user.valid?
      expect(user.errors[:password_confirmation]).to include("doesn't match Password")
    end
  end

  context "on a existing user" do
    before :each do
      @user = create(:user)
    end

    it "is valid with no changes" do
      expect(@user.valid?).to eq(true)
    end

    it "is invalid with empty password" do
      @user.password_digest = ""
      @user.valid?
      expect(@user.errors[:password]).to include("can't be blank")
    end

    it "is valid with a new valid password" do
      @user.password = "newlongpassword"
      @user.password_confirmation = "newlongpassword"
      expect(@user.valid?).to eq(true)
    end
  end

  context "adding gopay amount" do
    it "save default go pay credit when user created" do
      user = create(:user)
      expect(user.gopay).to eq(0)
    end

    it "is invalid with non numeric gopay" do
      user = create(:user)
      user.gopay = "1ooo"
      user.valid?
      expect(user.errors[:gopay]).to include("is not a number")
    end

    it "is invalid with gopay amount entry < 0" do
      user = create(:user)
      user.gopay = -2000
      user.valid?
      expect(user.errors[:gopay]).to include('must be greater than or equal to 0')
    end

    it "updates gopay amount with valid topup gopay" do
      user = create(:user, gopay: 50000)
      user.topup(50000)
      expect(user.gopay).to eq(100000)
    end

    it "is invalid with non numeric topup gopay" do
      user = create(:user)
      user.topup("5oooo")
      expect(user.errors[:gopay]).to include("is not a number")
    end

    it "is invalid with topup gopay amount entry < 0" do
      user = create(:user)
      user.topup(-20000)
      expect(user.errors[:gopay]).to include('must be greater than or equal to 0')
    end
  end
end
