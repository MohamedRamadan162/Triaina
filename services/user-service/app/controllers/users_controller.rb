# UsersController handles user-related actions such as fetching paginated users and retrieving a specific user by username.
class UsersController < ApiController
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
    user = list(User).find_by(id: params[:id])
    render_success(user: serializer(user))
  end

  # Creates a new user, writes it to the db and cache and returns JSON
  # POST /
  def create
    user = User.create!(user_params)
    render_success(user: serializer(user))
  end

  # Deletes a user by id
  # DELETE /:id
  def delete
    user = list(User).find_by(id: params[:id])
    user.destroy!
    render_success({ user: serializer(user) }, :no_content)
  end

  private

  # permitted user params for create action
  def user_params
    params.permit(:username, :email, :name)
  end
end
