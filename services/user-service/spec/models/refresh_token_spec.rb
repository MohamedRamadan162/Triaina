require 'rails_helper'

RSpec.describe RefreshToken, type: :model do
  let(:user) { create(:user) }
  let(:refresh_token) { create(:refresh_token, user: user) }

  describe "validations" do
    it { should validate_presence_of(:user_id) }

    it "validates presence of hashed_token" do
      token = build(:refresh_token)
      allow(token).to receive(:generate_token) # Prevent token generation
      token.hashed_token = nil
      token.validate
      expect(token.errors[:hashed_token]).to include("can't be blank")
    end

    it "validates presence of issued_at" do
      token = build(:refresh_token)
      allow(token).to receive(:set_issued_at) # Prevent auto-setting
      token.issued_at = nil
      token.validate
      expect(token.errors[:issued_at]).to include("can't be blank")
    end

    it "validates presence of expires_at" do
      token = build(:refresh_token)
      allow(token).to receive(:set_expiration) # Prevent auto-setting
      token.expires_at = nil
      token.validate
      expect(token.errors[:expires_at]).to include("can't be blank")
    end
  end

  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "callbacks" do
    it "generates a hashed token before validation" do
      token = build(:refresh_token, hashed_token: nil)
      token.valid?
      expect(token.hashed_token).to be_present
    end

    it "sets issued_at before validation" do
      token = build(:refresh_token, issued_at: nil)
      token.valid?
      expect(token.issued_at).to be_present
    end

    it "sets expiration date before validation" do
      token = build(:refresh_token, expires_at: nil)
      token.valid?
      expect(token.expires_at).to be_present
    end
  end

  describe "#revoke!" do
    it "sets revoked_at to current time" do
      expect(refresh_token.revoked_at).to be_nil
      refresh_token.revoke!
      expect(refresh_token.revoked_at).to be_present
      expect(refresh_token.revoked_at).to be <= Time.current
    end
  end

  describe "#expired?" do
    it "returns true if expires_at is in the past" do
      expired_token = create(:refresh_token, expires_at: 1.day.ago, user: user)
      expect(expired_token.expired?).to be true
    end

    it "returns false if expires_at is in the future" do
      expect(refresh_token.expired?).to be false
    end
  end

  describe "#revoked?" do
    it "returns true if revoked_at is set" do
      refresh_token.update!(revoked_at: Time.current)
      expect(refresh_token.revoked?).to be true
    end

    it "returns false if revoked_at is nil" do
      expect(refresh_token.revoked?).to be false
    end
  end
end
