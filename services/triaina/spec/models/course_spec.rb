require 'rails_helper'

RSpec.describe Course, type: :model do
  let(:course) { create(:course) }

  describe "validations" do
    it { should validate_presence_of(:name) }
  end

  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "callbacks" do
    it "generates a unique join code before validation" do
      course = build(:course, join_code: nil)
      course.valid?
      expect(course.join_code).to be_present
      course.save

      another_course = build(:course, join_code: course.join_code)
      expect(another_course).to be_invalid
    end
  end

  describe "scopes" do
    it "filters by id" do
      course1 = create(:course)
      course2 = create(:course)
      expect(Course.filter_by_id(course1.id)).to include(course1)
      expect(Course.filter_by_id(course1.id)).not_to include(course2)
    end

    it "filters by name" do
      course1 = create(:course, name: "Math 101")
      course2 = create(:course, name: "Science 101")
      expect(Course.filter_by_name("Math")).to include(course1)
      expect(Course.filter_by_name("Math")).not_to include(course2)
    end

    it "filters by created_by" do
      user1 = create(:user)
      user2 = create(:user)
      course1 = create(:course, created_by: user1.id)
      course2 = create(:course, created_by: user2.id)
      expect(Course.filter_by_created_by(user1.id)).to include(course1)
      expect(Course.filter_by_created_by(user1.id)).not_to include(course2)
    end
  end
end
