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

  private

  def render_message(message)
    ChatMessageSerializer.render(message)
  end
end
