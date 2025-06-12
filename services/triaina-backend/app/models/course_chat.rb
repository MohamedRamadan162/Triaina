class CourseChat < ApplicationRecord
  ######################### Validations #########################
  validates :name, presence: true, uniqueness: { scope: :course_id }

  ############################################# ASSOCIATIONS #############################################
  belongs_to :course, class_name: "Course", foreign_key: "course_id"
  has_many :chat_messages, dependent: :destroy

  ############################################## METHODS #############################################
  def send_message(user, content)
    chat_messages.create!(user: user, content: content)
  end
end
