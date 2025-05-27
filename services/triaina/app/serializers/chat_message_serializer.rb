class ChatMessageSerializer < ApplicationSerializer
  attributes :id, :content, :created_at, :updated_at, :user_id, :chat_channel_id

  def user_id
    object.user.id
  end

  def chat_id
    object.chat_channel.id
  end
end
