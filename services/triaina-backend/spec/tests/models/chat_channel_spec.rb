require 'rails_helper'

RSpec.describe CourseChat, type: :model do
  describe "associations" do
    it { should belong_to(:course) }
    it { should have_many(:chat_messages).dependent(:destroy) }
  end

  describe "validations" do
    subject { build(:course_chat) }
    it { should validate_presence_of(:name) }
    it { should validate_uniqueness_of(:name).scoped_to(:course_id) }
  end
end
