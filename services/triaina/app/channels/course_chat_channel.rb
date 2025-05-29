class CourseChatChannel < ApplicationCable::Channel
  def subscribed
    chat_channel = ChatChannel.find(params[:channel_id])
    stream_for chat_channel
  end

  def unsubscribed
  end

  # Called by client to send message
  def send_message(data)
    chat_channel = ChatChannel.find(params[:channel_id])
    message = chat_channel.chat_messages.create!(
      user: connection.current_user,
      content: data["message"]
    )
    CourseChatChannel.broadcast_to(chat_channel, {
      message: render_message(message)
    })
  end

  def update_message(data)
    chat_channel = ChatChannel.find(params[:channel_id])
    message = chat_channel.chat_messages.find(data["message_id"])
    if message.user == connection.current_user
      message.update!(content: data["content"])
      CourseChatChannel.broadcast_to(chat_channel, {
        message: render_message(message)
      })
    else
      reject
    end
  end

  def delete_message(data)
    chat_channel = ChatChannel.find(params[:channel_id])
    message = chat_channel.chat_messages.find(data["message_id"])
    if message.user == connection.current_user
      message.destroy!
      CourseChatChannel.broadcast_to(chat_channel, {
        message_id: message.id
      })
    else
      reject
    end
  end

  def fetch_messages
    chat_channel = ChatChannel.find(params[:channel_id])
    messages = chat_channel.chat_messages.order(created_at: :asc)
    CourseChatChannel.broadcast_to(chat_channel, {
      messages: messages.map { |msg| render_message(msg) }
    })
  end

  private

  def render_message(message)
    ChatMessageSerializer.render(message)
  end
end
