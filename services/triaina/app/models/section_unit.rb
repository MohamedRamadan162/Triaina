class SectionUnit < ApplicationRecord
  has_one_attached :content
  belongs_to :section, class_name: "CourseSection", foreign_key: "section_id"

  validates :title, presence: true
  validates :order_index, presence: true, uniqueness: { scope: :section_id }

  scope :filter_by_id, ->(id) { where(id: id) }
  scope :filter_by_section_id, ->(section_id) { where(section_id: section_id) }
  scope :filter_by_section_and_order, ->(section_id, order_index) {
    where(section_id: section_id, order_index: order_index)
  }
end
