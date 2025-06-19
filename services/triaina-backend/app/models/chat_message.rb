class ChatMessage < ApplicationRecord
  ######################### Validations #########################
  validates :content, presence: true
  validates :user_id, presence: true
  validates :course_chat_id, presence: true

  ############################################# ASSOCIATIONS #############################################
  belongs_to :user, class_name: "User", foreign_key: "user_id"
  belongs_to :course_chat, class_name: "CourseChat", foreign_key: "course_chat_id"

  ############################################## SCOPES #############################################
  scope :filter_by_course_chat_id, ->(course_chat_id) { where(course_chat_id: course_chat_id) }
  scope :filter_by_user_id, ->(user_id) { where(user_id: user_id) }
end
