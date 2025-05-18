class CourseSection < ApplicationRecord
  belongs_to :course, class_name: "Course", foreign_key: "course_id"
  has_many :section_units, dependent: :destroy, foreign_key: "section_id"

  before_validation :create_order_index

  validates :title, presence: true
  validates :order_index, presence: true, uniqueness: { scope: :course_id }

  scope :filter_by_id, ->(id) { where(id: id) }
  scope :filter_by_course_id, ->(course_id) { where(course_id: course_id) }
  scope :filter_by_course_and_order, ->(course_id, order_index) {
    where(course_id: course_id, order_index: order_index)
  }

  private

  def create_order_index
    return if self.order_index.present?
    max_index = CourseSection.where(course_id: self.course_id).maximum(:order_index) || 0
    self.order_index = max_index + 1
  end
end
