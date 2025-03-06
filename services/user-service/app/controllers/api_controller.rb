class ApiController < ApplicationController
  before_action :authenticate_request!

  # Add pagination metadata
  after_action { pagy_headers_merge(@pagy) if @pagy }

  # # Policies
  # def pundit_user
  #   @current_user
  # end

  # Authenticate user
  def authenticate_request!
    jwt_token = cookies.signed[:jwt]
    refresh_token = cookies.signed[:refresh_token]

    # Check if jwt token is isn't expired
    begin
      decoded_jwt = JsonWebToken.decode(jwt_token)
      @current_user_id = decoded_jwt[:user_id]
      return
    rescue JWT::ExpiredSignature, JWT::DecodeError
    end

    # Check if refresh token is valid
    decoded_refresh_token = RefreshToken.find_by(hashed_token: Digest::SHA256.hexdigest(refresh_token))
    if !decoded_refresh_token || decoded_refresh_token.expired? || decoded_refresh_token.revoked?
      render_error("Unauthorized", status: :unauthorized)
    end

    # Generate new jwt token
    jwt = JsonWebToken.encode(user_id: decoded_refresh_token.user_id)
    cookies.signed[:jwt] = {
      value: jwt,
      httponly: true,
      secure: Rails.env.production?,
      same_site: :strict
    }

    # Revoke old refresh token and generate new one
    decoded_refresh_token.revoke!

    refresh_token = RefreshToken.create!(user_id: decoded_refresh_token.user_id)
    cookies.signed[:refresh_token] = {
      value: refresh_token.raw_token,
      httponly: true,
      secure: Rails.env.production?,
      same_site: :strict
    }

    @current_user_id = refresh_token[:user_id]
    puts "Current user is #{@current_user_id}"
  end

  # List and filter records
  def list(model, filtering_params: filtering_params(), multiselection_filtering_params: multiselection_filtering_params(), ordering_params: ordering_params())
    records = model.filter_by(filtering_params, multiselection_filtering_params).order_by(ordering_params)
    @pagy, records = pagy(records) unless params[:page].to_i == -1
    records
  end

  def filtering_params
    []
  end

  def multiselection_filtering_params
    []
  end

  def ordering_params
    { order_by_created_at: :desc }
  end

  def serializer(objects, params: {}, serializer_class: serializer_class())
    serializer_class.render(objects, params)
  end

  def controller_model
    controller_name.classify.constantize
  end

  def serializer_class
    "#{controller_model}Serializer".constantize
  end
end
