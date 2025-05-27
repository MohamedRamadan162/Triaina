class Api::V1::AuthController < Api::ApiController
  skip_before_action :authenticate_request!

  # Sign up
  # POST /signup
  def signup
    user = User.create!(sign_up_profile_params)
    UserSecurity.create!(sign_up_security_params.merge(user_id: user.id))
    Rails.cache.write("user_#{user.id}", user)
    UserEventProducer.publish_sign_up(user)
    render_success({ user: serializer(user) }, :created)
  end

  # Sign in
  # POST /login
  def login
    user = User.find_by(email: sign_in_params[:email])
    # Check if the user exists
    if user.nil?
      return render_error("Invalid email or password", :unauthorized)
    end
    user_security = UserSecurity.find(user[:id])
    if user_security&.authenticate(sign_in_params[:password])
      # Cache user
      Rails.cache.write("user_#{user.id}", user)

      # return JWT token and refresh token as cookies
      jwt = JsonWebToken.encode(user_id: user[:id])
      refresh_token = RefreshToken.create!(user_id: user.id)
      cookies.signed[:jwt] = {
        value: jwt,
        httponly: true,
        secure: Rails.env.production?,
        same_site: :strict
      }
      cookies.signed[:refresh_token] ={
        value: refresh_token.raw_token,
        httponly: true,
        secure: Rails.env.production?,
        same_site: :strict
      }

      render_success(user: serializer(user))
    else
      render_error("Invalid email or password", :unauthorized)
    end
  end


  private

  def sign_up_profile_params
    params.permit(:name, :username, :email)
  end

  def sign_up_security_params
    params.permit(:password, :password_confirmation)
  end

  def sign_in_params
    params.permit(:email, :password)
  end

  def serializer_class
    "UserSerializer".constantize
  end
end
