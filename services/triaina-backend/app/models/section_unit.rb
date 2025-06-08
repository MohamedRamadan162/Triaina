class SectionUnit < ApplicationRecord
  has_one_attached :content

  ######################### Associations #########################
  belongs_to :course_section, class_name: "CourseSection", foreign_key: "section_id"

  ########################## Validations #########################
  validates :title, presence: true
  validates :order_index, presence: true, uniqueness: { scope: :section_id }

  ############################ Hooks ############################
  before_validation :create_order_index

  ############################### Scopes ############################
  scope :filter_by_id, ->(id) { where(id: id) }
  scope :filter_by_section_id, ->(section_id) { where(section_id: section_id) }
  scope :filter_by_section_and_order, ->(section_id, order_index) {
    where(section_id: section_id, order_index: order_index)
  }

  private

  def create_order_index
    return if self.order_index.present?
    max_index = SectionUnit.where(section_id: self.section_id).maximum(:order_index) || 0
    self.order_index = max_index + 1
  end
end
