require "pagy/extras/metadata"
include Pagy::Backend

class UsersController < ApplicationController
  def paginatedUsers(page = 1, limit = 100)
    pagy, users = pagy(User.all, items: limit, page: page)
    return users, pagy
  end

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
      curr_page: pagy.page,
      prev_page: pagy.prev,
      next_page: pagy.next,
      num_pages: pagy.pages
      }
    }, status: :ok
  end
end
