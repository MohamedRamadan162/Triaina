require 'rails_helper'

RSpec.describe CourseSection, type: :model do
  let(:course) { create(:course) }
  let(:course_section) { create(:course_section, course: course) }

  describe 'associations' do
    it { should belong_to(:course).class_name('Course').with_foreign_key('course_id') }
  end

  describe 'validations' do
    subject { build(:course_section, course: course, order_index: 1, title: "Introduction") }

    it { should validate_presence_of(:title) }
  end

  describe 'scopes' do
    describe '.filter_by_id' do
      it 'returns the correct course section' do
        course_section_2 = create(:course_section)
        expect(CourseSection.filter_by_id(course_section.id)).to include(course_section)
        expect(CourseSection.filter_by_id(course_section.id)).not_to include(course_section_2)
      end
    end

    describe '.filter_by_course_id' do
      it 'returns the correct course sections' do
        expect(CourseSection.filter_by_course_id(course.id)).to include(course_section)
      end
    end

    describe '.filter_by_course_and_order' do
      it 'returns the correct course section' do
        expect(CourseSection.filter_by_course_and_order(course.id, course_section.order_index)).to include(course_section)
      end
    end
  end
end
