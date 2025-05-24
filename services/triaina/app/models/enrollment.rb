class Enrollment < ApplicationRecord
  ######################### Enums #########################
  enum :status, { active: 0, completed: 1, dropped: 2 }
  ######################### Associations #########################
  belongs_to :user
  belongs_to :course
  belongs_to :role

  ######################### Validations #########################
  validates :user_id, uniqueness: { scope: :course_id, message: "is already enrolled in this course" }
  validates :status, presence: true
end 