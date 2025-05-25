require 'rails_helper'

RSpec.describe SectionUnit, type: :model do
  let(:section_unit) { create(:section_unit) }
  let(:course_section) { section_unit.course_section }

  describe 'associations' do
    it { should belong_to(:course_section).class_name('CourseSection').with_foreign_key('section_id') }
  end

  describe 'validations' do
    subject { build(:section_unit, course_section: course_section, order_index: 1, title: "Introduction") }

    it { should validate_presence_of(:title) }
  end

  describe 'scopes' do
    describe '.filter_by_id' do
      it 'returns the correct section unit' do
        section_unit_2 = create(:section_unit)
        expect(SectionUnit.filter_by_id(section_unit.id)).to include(section_unit)
        expect(SectionUnit.filter_by_id(section_unit.id)).not_to include(section_unit_2)
      end
    end

    describe '.filter_by_section_id' do
      it 'returns the correct section units' do
        expect(SectionUnit.filter_by_section_id(course_section.id)).to include(section_unit)
      end
    end

    describe '.filter_by_course_and_order' do
      it 'returns the correct section unit' do
        expect(SectionUnit.filter_by_section_and_order(course_section.id, section_unit.order_index)).to include(section_unit)
      end
    end
  end

  describe 'file attachment' do
    it "attaches a pdf to the section unit" do
      file = File.open(Rails.root.join("spec/fixtures/files/test_pdf.pdf"))
      section_unit.content.attach(
          io: file,
          filename: "test_pdf.pdf",
          content_type: "application/pdf"
      )

      expect(section_unit.content).to be_attached
      expect(section_unit.content.content_type).to eq("application/pdf")
      expect(section_unit.content.filename.to_s).to eq("test_pdf.pdf")
      expect(section_unit.content.byte_size).to eq(file.size)

      downloaded_data = section_unit.content.download
      file.rewind
      expect(downloaded_data).to eq(file.read)
    end

    it "attaches a video to the section unit" do
      file = File.open(Rails.root.join("spec/fixtures/files/test_video.mp4"))
      section_unit.content.attach(
          io: file,
          filename: "test_video.mp4",
          content_type: "video/mp4"
      )

      expect(section_unit.content).to be_attached
      expect(section_unit.content.content_type).to eq("video/mp4")
      expect(section_unit.content.filename.to_s).to eq("test_video.mp4")
      expect(section_unit.content.byte_size).to eq(file.size)

      downloaded_data = section_unit.content.download
      file.rewind
      expect(downloaded_data).to eq(file.read)
    end
  end
end
