class Api::V1::Courses::ChatChannelsController < Api::ApiController
  before_action :authorize_request

  ###########################
  # List all chat channels in a course
  # GET /api/v1/courses/:course_id/chat_channels
  ############################
  def index
    course = Course.find(params[:course_id])
    chat_channels = course.chat_channels.order(created_at: :asc)
    render_success(chat_channels: serializer(chat_channels))
  end

  ###########################
  # Retrieves a chat channel by id
  # GET /api/v1/courses/:course_id/chat_channels/:id
  ############################
  def show
    course = Course.find(params[:course_id])
    chat_channel = course.chat_channels.find(params[:id])
    render_success(chat_channel: serializer(chat_channel))
  end

  ###########################
  # Create a new chat channel in a course
  # POST /api/v1/courses/:course_id/chat_channels
  ############################
  def create
    course = Course.find(params[:course_id])
    chat_channel = course.chat_channels.create!(create_chat_channel_params)

    render_success({ chat_channel: serializer(chat_channel) }, :created)
  end

  ###########################
  # Update a chat channel by id
  # PATCH /api/v1/courses/:course_id/chat_channels/:id
  ############################
  def update
    course = Course.find(params[:course_id])
    chat_channel = course.chat_channels.find(params[:id])
    chat_channel.update!(update_chat_channel_params)
    render_success({ chat_channel: serializer(chat_channel) })
  end

  ###########################
  # Deletes a chat channel by id
  # DELETE /api/v1/courses/:course_id/chat_channels/:id
  ############################
  def destroy
    course = Course.find(params[:course_id])
    chat_channel = course.chat_channels.find(params[:id])
    chat_channel.destroy!
    render_success({}, :no_content)
  end

  private

  def create_chat_channel_params
    params.permit(:name, :description)
  end

  def update_chat_channel_params
    params.permit(:name, :description)
  end

  def authorize_request
    authorize(User, policy_class: Course::ChatChannelPolicy)
  end
end
