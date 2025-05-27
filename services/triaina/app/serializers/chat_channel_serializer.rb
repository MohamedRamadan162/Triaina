class ChatChannelSerializer < ApplicationSerializer
  attributes :id, :name, :created_at, :updated_at

  has_many :messages, serializer: ChatMessageSerializer

  def messages
    object.chat_messages.order(created_at: :desc).limit(10)
  end
end
