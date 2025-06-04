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

# == Schema Information
#
# Table name: enrollments
#
#  id         :bigint           not null, primary key
#  user_id    :uuid             not null
#  course_id  :uuid             not null
#  role_id    :bigint           not null
#  status     :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null


# Indexes
#  index_enrollments_on_user_id_and_course_id  (user_id,course_id) UNIQUE
#
