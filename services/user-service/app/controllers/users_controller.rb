include Pagy::Backend

# UsersController handles user-related actions such as fetching paginated users and retrieving a specific user by username.
class UsersController < ApplicationController
  # Fetches a paginated list of users.
  #
  # @param page [Integer] the page number to fetch, defaults to 1.
  # @param limit [Integer] the number of users per page, defaults to 100.
  # @return [Array] an array containing the paginated users and pagination metadata.
  def paginatedUsers(page = 1, limit = 100)
    begin
    pagy, users = pagy(User.all, page: page, limit: limit)

    # Out of bounds page
    rescue Pagy::OverflowError
      pagy = Pagy.new(count: User.count, limit: limit)
      return [], pagy
    end
    return users, pagy
  end

  # Retrieves a paginated list of users filtered by request params and renders it as JSON.
  #
  # @return [void]
  def getAllUsers
    # Get page and number params variables
    page = params[:page].to_i > 0 ? params[:page].to_i : 1

    # Return paginated users with metadata
    users, pagy = paginatedUsers(page)

    render json: {
      users:,
      pagination: {
      count: pagy.count,
      users_per_page: pagy.limit,
      curr_page: users.empty? ? page: pagy.page,
      prev_page: pagy.prev,
      next_page: pagy.next,
      num_pages: pagy.pages
      }
    }, status: :ok
  end

  # Retrieves a user by username and renders it as JSON.
  #
  # @return [void]
  def getUser
    # Check if username exists
    if params[:username].blank?
      render json: { error: "Username is required" }, status: :bad_request
    end

    # Check cache for user if not exist query db
    user = Rails.cache.fetch("users/#{params[:username]}") do
      User.find_by(username: params[:username])
    end

    # If user doesn't exist return and send a JSON error
    return render json: { error: "User not found" }, status: :not_found if user.nil?

    render json: { user: }, status: :ok
  end
end
