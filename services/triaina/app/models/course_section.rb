class CourseSection < ApplicationRecord
  belongs_to :course, class_name: "Course", foreign_key: "course_id"

  validates :title, presence: true
  validates :order_index, presence: true, uniqueness: { scope: :course_id }

  scope :filter_by_id, ->(id) { where(id: id) }
  scope :filter_by_course_id, ->(course_id) { where(course_id: course_id) }
  scope :filter_by_course_and_order, ->(course_id, order_index) {
    where(course_id: course_id, order_index: order_index)
  }
end
