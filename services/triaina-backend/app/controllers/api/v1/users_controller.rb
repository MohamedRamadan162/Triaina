# frozen_string_literal: true

# UsersController handles user-related actions such as fetching paginated users and retrieving a specific user by username
class Api::V1::UsersController < Api::ApiController
  before_action :authorize_request, only: [ :index, :show, :delete, :update ]
  before_action :find_user_by_id, only: [ :show, :delete, :update ]

  # Retrieves the current user
  # GET /me
  def me
    authorize @current_user, :me?
    render_success({ user: serializer(@current_user) })
  end

  # Update current user
  # PATCH /me
  def update_me
    authorize @current_user, :update_me?
    @current_user.update!(update_user_params)
    Rails.cache.write("user_#{@current_user_id}", @current_user)
    UserEventProducer.publish_update_user(@current_user)
    render_success({ user: serializer(@current_user) })
  end

  # Deletes the current user
  # DELETE /me
  def delete_me
    authorize @current_user, :delete_me?
    @current_user.destroy!
    Rails.cache.delete("user_#{@current_user_id}")
    UserEventProducer.publish_delete_user(@current_user)
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

  def authorize_request
    authorize(User, policy_class: UserPolicy)
  end
end
