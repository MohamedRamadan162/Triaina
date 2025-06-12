class CourseChatChannel < ApplicationCable::Channel
  include Pagy::Backend

  def subscribed
    @course_chat = CourseChat.find(params[:channel_id])
    stream_for @course_chat
  end

  def unsubscribed
  end

  # Called by client to send message
  def send_message(data)
    message = @course_chat.chat_messages.create!(
      user: current_user,
      content: data["message"]
    )
    CourseCourseChat.broadcast_to(@course_chat, {
      action: "new_message",
      message: render_message(message)
    })
  end

  def update_message(data)
    message = @course_chat.chat_messages.find(data["message_id"])
    if message.user == current_user
      message.update!(content: data["message"])
      CourseCourseChat.broadcast_to(@course_chat, {
        action: "updated_message",
        message: render_message(message)
      })
    else
      reject
    end
  end

  def delete_message(data)
    message = @course_chat.chat_messages.find(data["message_id"])
    if message.user == current_user
      message.destroy!
      CourseCourseChat.broadcast_to(@course_chat, {
        action: "deleted_message",
        message_id: message.id
      })
    else
      reject
    end
  end

  def fetch_messages(data)
    pagy, messages = pagy(@course_chat.chat_messages.order(created_at: :desc), items: 100, page: data["page"] || 1)

    CourseCourseChat.broadcast_to(@course_chat, {
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
    CourseCourseChat.broadcast_to(@course_chat, {
      type: "error",
      message: "Page not found"
    })
  end

  private

  def render_message(message)
    ChatMessageSerializer.render(message)
  end
end
