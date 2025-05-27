class ChatChannel < ApplicationRecord
  ######################### Validations #########################
  validates :name, presence: true, uniqueness: { scope: :course_id }

  ############################################# ASSOCIATIONS #############################################
  belongs_to :course, class_name: "Course", foreign_key: "course_id"
end
