# frozen_string_literal: true

# UsersController handles user-related actions such as fetching paginated users and retrieving a specific user by username
class UsersController < ApiController
  before_action :find_current_user_by_id, only: %i[me update_me delete_me]
  before_action :find_user_by_id, only: %i[show update delete]

  # Retrieves the current user
  # GET /me
  def me
    render_success({ user: serializer(@user) })
  end

  # Update current user
  # PATCH /me
  def update_me
    @user.update!(update_user_params)
    Rails.cache.write("user_#{@current_user_id}", @user)
    UserEventProducer.publish_update_user(@user)
    render_success({ user: serializer(@user) })
  end

  # Deletes the current user
  # DELETE /me
  def delete_me
    @user.destroy!
    Rails.cache.delete("user_#{@current_user_id}")
    UserEventProducer.publish_delete_user(@user)
    render_success({}, :no_content)
  end

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

  # Deletes a user by id
  # DELETE /:id
  def delete
    @user.destroy!
    Rails.cache.delete("user_#{@user.id}")
    UserEventProducer.publish_delete_user(@user)
    render_success({}, :no_content)
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

  def find_user_by_id
    @user ||= Rails.cache.fetch("user_#{params[:id]}") do
      User.find_by!(id: params[:id])
    end
  end

  def find_current_user_by_id
    @user ||= Rails.cache.fetch("user_#{@current_user_id}") do
      User.find_by!(id: @current_user_id)
    end
  end
end
