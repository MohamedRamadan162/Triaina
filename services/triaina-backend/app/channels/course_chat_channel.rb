class CourseChatChannel < ApplicationCable::Channel
  include Pagy::Backend

  def subscribed
    @chat_channel = ChatChannel.find(params[:channel_id])
    stream_for @chat_channel
  end

  def unsubscribed
  end

  # Called by client to send message
  def send_message(data)
    message = @chat_channel.chat_messages.create!(
      user: current_user,
      content: data["message"]
    )
    CourseChatChannel.broadcast_to(@chat_channel, {
      action: "new_message",
      message: render_message(message)
    })
  end

  def update_message(data)
    message = @chat_channel.chat_messages.find(data["message_id"])
    if message.user == current_user
      message.update!(content: data["message"])
      CourseChatChannel.broadcast_to(@chat_channel, {
        action: "updated_message",
        message: render_message(message)
      })
    else
      reject
    end
  end

  def delete_message(data)
    message = @chat_channel.chat_messages.find(data["message_id"])
    if message.user == current_user
      message.destroy!
      CourseChatChannel.broadcast_to(@chat_channel, {
        action: "deleted_message",
        message_id: message.id
      })
    else
      reject
    end
  end

  def fetch_messages(data)
    pagy, messages = pagy(@chat_channel.chat_messages.order(created_at: :desc), items: 100, page: data["page"] || 1)

    CourseChatChannel.broadcast_to(@chat_channel, {
      action: "fetched_messages",
      messages: messages.map { |msg| render_message(msg) },
      pagy: {
        page: pagy.page,
        pages: pagy.pages,
        count: pagy.count,
        prev: pagy.prev,
        next: pagy.next
      }
    })

  rescue Pagy::OverflowError
    CourseChatChannel.broadcast_to(@chat_channel, {
      type: "error",
      message: "Page not found"
    })
  end

  private

  def render_message(message)
    ChatMessageSerializer.render(message)
  end
end
