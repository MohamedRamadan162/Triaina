require 'rails_helper'

RSpec.describe User, type: :model do
  include Constants

  # FactoryBot setup (if using factories)
  let(:user) { create(:user, username: "johndoe2000", name: "John Doe", email: "TEST@EXAMPLE.COM", email_verified: true) }
  let(:invalid_user) { build(:user, username: "inv", name: "Invalid User", email: "TEST", email_verified: false) }

  describe "validations" do
    subject { build(:user, username: "johndoe2000", name: "John Doe", email: "TEST@EXAMPLE.COM", email_verified: true) }

    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username).case_insensitive }
    it { should validate_length_of(:username).is_at_least(4) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it "validates email format using regex" do
      expect(user.email).to match(Constants::EMAIL_REGEX)
      expect(invalid_user.email).not_to match(Constants::EMAIL_REGEX)
    end
  end

  describe "#is_verified?" do
    it "return true" do
      expect(user.is_verified?).to eq(true)
    end
    it "return false" do
      expect(invalid_user.is_verified?).to eq(false)
    end
  end

  describe "scopes" do
    it "filters by id" do
      expect(User.filter_by_id(user.id)).to include(user)
    end

    it "filters by username (case insensitive)" do
      expect(User.filter_by_username("JOHNDOE2000")).to include(user)
    end

    it "filters by email (case insensitive)" do
      expect(User.filter_by_email("test@example.com")).to include(user)
    end
  end

  describe "callbacks" do
    it "sanitizes attributes before validation" do
      dirty_user = User.new(username: "  spaced_user  ", email: "  test@domain.com  ")
      dirty_user.valid?

      expect(dirty_user.username).to eq("spaced_user")
      expect(dirty_user.email).to eq("test@domain.com")
    end
  end
end
