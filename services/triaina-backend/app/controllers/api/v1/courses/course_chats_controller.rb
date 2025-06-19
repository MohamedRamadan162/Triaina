class Api::V1::Courses::CourseChatsController < Api::ApiController
  before_action :authorize_request

  ###########################
  # List all chat channels in a course
  # GET /api/v1/courses/:course_id/course_chats
  ############################
  def index
    course = Course.find(params[:course_id])
    course_chats = course.course_chats.order(created_at: :asc)
    render_success(course_chats: serializer(course_chats))
  end

  ###########################
  # Retrieves a chat channel by id
  # GET /api/v1/courses/:course_id/course_chats/:id
  ############################
  def show
    course = Course.find(params[:course_id])
    course_chat = course.course_chats.find(params[:id])
    render_success(course_chat: serializer(course_chat))
  end

  ###########################
  # Create a new chat channel in a course
  # POST /api/v1/courses/:course_id/course_chats
  ############################
  def create
    course = Course.find(params[:course_id])
    course_chat = course.course_chats.create!(create_course_chat_params)

    render_success({ course_chat: serializer(course_chat) }, :created)
  end

  ###########################
  # Update a chat channel by id
  # PATCH /api/v1/courses/:course_id/course_chats/:id
  ############################
  def update
    course = Course.find(params[:course_id])
    course_chat = course.course_chats.find(params[:id])
    course_chat.update!(update_course_chat_params)
    render_success({ course_chat: serializer(course_chat) })
  end

  ###########################
  # Deletes a chat channel by id
  # DELETE /api/v1/courses/:course_id/course_chats/:id
  ############################
  def destroy
    course = Course.find(params[:course_id])
    course_chat = course.course_chats.find(params[:id])
    course_chat.destroy!
    render_success({}, :no_content)
  end

  private

  def create_course_chat_params
    params.permit(:name, :description)
  end

  def update_course_chat_params
    params.permit(:name, :description)
  end

  def authorize_request
    authorize(User, policy_class: Course::CourseChatPolicy)
  end
end
