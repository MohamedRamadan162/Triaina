class Api::V1::Courses::CourseChats::ChatMessagesController < Api::ApiController
  before_action :authorize_request

  ###########################
  # List all messages in a chat channel
  # GET /api/v1/courses/:course_id/course_chats/:course_chat_id/chat_messages
  ############################
  def index
    course = Course.find(params[:course_id])
    course_chat = course.course_chats.find(params[:course_chat_id])
    messages = course_chat.chat_messages.order(created_at: :asc)
    render_success(messages: serializer(messages))
  end

  ###########################
  # Retrieves a chat message by id
  # GET /api/v1/courses/:course_id/course_chats/:course_chat_id/chat_messages/:id
  # ############################
  def show
    course = Course.find(params[:course_id])
    course_chat = course.course_chats.find(params[:course_chat_id])
    message = course_chat.chat_messages.find(params[:id])
    render_success(message: serializer(message))
  end

  ###########################
  # Create a new message in a chat channel
  # POST /api/v1/courses/:course_id/course_chats/:course_chat_id/chat_messages
  # ############################
  def create
    course = Course.find(params[:course_id])
    course_chat = course.course_chats.find(params[:course_chat_id])
    message = course_chat.chat_messages.create!(create_chat_message_params.merge(user: @current_user))

    render_success({ message: serializer(message) }, :created)
  end

  ###########################
  # Update a chat message by id
  # PATCH /api/v1/courses/:course_id/course_chats/:course_chat_id/chat_messages/:id
  # ############################
  def update
    course = Course.find(params[:course_id])
    course_chat = course.course_chats.find(params[:course_chat_id])
    message = course_chat.chat_messages.find(params[:id])
    message.update!(update_chat_message_params)
    render_success({ message: serializer(message) })
  end

  ###########################
  # Deletes a chat message by id
  # DELETE /api/v1/courses/:course_id/course_chats/:course_chat_id/chat_messages/:id
  # ############################
  def destroy
    course = Course.find(params[:course_id])
    course_chat = course.course_chats.find(params[:course_chat_id])
    message = course_chat.chat_messages.find(params[:id])
    message.destroy!
    render_success({}, :no_content)
  end

  private

  def create_chat_message_params
    params.permit(:content)
  end

  def update_chat_message_params
    params.permit(:content)
  end

  def authorize_request
    authorize(User, policy_class: Course::CourseChat::ChatMessagePolicy)
  end
end
