require 'rails_helper'

RSpec.describe UserSecurity, type: :model do
  let(:user) { create(:user) }
  let(:user_security) { user.user_security }
  let(:valid_password) { TestConstants::DEFAULT_USER[:password] }
  let(:invalid_user_security) { build(:user_security, user: user, password: "123") }

  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "validations" do
    it { should validate_presence_of(:password) }

    it "validates password format using regex" do
      expect(valid_password).to match(Constants::PASSWORD_REGEX)
      expect(invalid_user_security.password).not_to match(Constants::PASSWORD_REGEX)
    end
  end

  describe "database structure" do
    it "has a primary key set to user_id" do
      expect(UserSecurity.primary_key).to eq("user_id")
    end
  end
end
