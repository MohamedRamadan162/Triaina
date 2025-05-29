class Api::V1::Courses::ChatChannels::ChatMessagesController < Api::ApiController
  ###########################
  # List all messages in a chat channel
  # GET /api/v1/courses/:course_id/chat_channels/:chat_channel_id/chat_messages
  ############################
  def index
    course = Course.find(params[:course_id])
    chat_channel = course.chat_channels.find(params[:chat_channel_id])
    messages = chat_channel.chat_messages.order(created_at: :asc)
    render_success(messages: serializer(messages))
  end

  ###########################
  # Retrieves a chat message by id
  # GET /api/v1/courses/:course_id/chat_channels/:chat_channel_id/chat_messages/:id
  # ############################
  def show
    course = Course.find(params[:course_id])
    chat_channel = course.chat_channels.find(params[:chat_channel_id])
    message = chat_channel.chat_messages.find(params[:id])
    render_success(message: serializer(message))
  end

  ###########################
  # Create a new message in a chat channel
  # POST /api/v1/courses/:course_id/chat_channels/:chat_channel_id/chat_messages
  # ############################
  def create
    course = Course.find(params[:course_id])
    chat_channel = course.chat_channels.find(params[:chat_channel_id])
    message = chat_channel.chat_messages.create!(create_chat_message_params.merge(user: @current_user))

    render_success({ message: serializer(message) }, :created)
  end

  ###########################
  # Update a chat message by id
  # PATCH /api/v1/courses/:course_id/chat_channels/:chat_channel_id/chat_messages/:id
  # ############################
  def update
    course = Course.find(params[:course_id])
    chat_channel = course.chat_channels.find(params[:chat_channel_id])
    message = chat_channel.chat_messages.find(params[:id])
    message.update!(update_chat_message_params)
    render_success({ message: serializer(message) })
  end

  ###########################
  # Deletes a chat message by id
  # DELETE /api/v1/courses/:course_id/chat_channels/:chat_channel_id/chat_messages/:id
  # ############################
  def destroy
    course = Course.find(params[:course_id])
    chat_channel = course.chat_channels.find(params[:chat_channel_id])
    message = chat_channel.chat_messages.find(params[:id])
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
end
