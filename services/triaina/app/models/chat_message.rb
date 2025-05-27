class ChatMessage < ApplicationRecord
  ######################### Validations #########################
  validates :content, presence: true
  validates :user_id, presence: true
  validates :chat_channel_id, presence: true

  ############################################# ASSOCIATIONS #############################################
  belongs_to :user, class_name: "User", foreign_key: "user_id"
  belongs_to :chat_channel, class_name: "ChatChannel", foreign_key: "chat_channel_id"

  ############################################## SCOPES #############################################
  scope :filter_by_chat_channel_id, ->(chat_channel_id) { where(chat_channel_id: chat_channel_id) }
  scope :filter_by_user_id, ->(user_id) { where(user_id: user_id) }
end
