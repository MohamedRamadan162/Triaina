# frozen_string_literal: true

# UsersController handles user-related actions such as fetching paginated users and retrieving a specific user by username.
class UsersController < ApiController
  include UserEventProducer
  before_action :find_user_by_id, only: %i[show update delete] # Pre operation hook

  # List all users and render them as JSON.
  # GET /
  def index
    # List all users
    users = list(User)
    render_success(users: serializer(users))
  end

  # Retrieves a user by id
  # Get /:id
  def show
    render_success(user: serializer(@user))
  end

  # Creates a new user, writes it to the db and cache and returns JSON
  # POST /
  def create
    user = User.create!(create_user_params)
    UserEventProducer.publish_create_user(user)
    render_success({ user: serializer(user) }, :created)
  end

  # Deletes a user by id
  # DELETE /:id
  def delete
    @user.destroy!
    Rails.cache.delete("user_#{@user.id}")
    UserEventProducer.publish_delete_user(@user)
    render_success({ user: serializer(user) }, :no_content)
  end

  # Update a user by id
  # PATCH /:id
  def update
    @user.update!(update_user_params)
    Rails.cache.write("user_#{@user.id}", @user)
    UserEventProducer.publish_update_user(@user)
    render_success({ user: serializer(@user) })
  end

  private

  # permitted user params for create action
  def create_user_params
    params.permit(:username, :email, :name)
  end

  # permitted user params for update action
  def update_user_params
    params.permit(:username, :email, :name)
  end

  # filtering params for lookups
  def filtering_params
    params.permit(:username, :email)
  end

  # lookup user using id
  def find_user_by_id
    @user ||= Rails.cache.fetch("user_#{params[:id]}") do
      User.find_by(id: params[:id])
    end
  end
end
