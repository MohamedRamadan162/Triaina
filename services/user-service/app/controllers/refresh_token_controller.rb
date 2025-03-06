class RefreshTokenController < ApiController
  skip_before_action :authenticate_request!

  # Send token, generate new jwt and refresh token and send them back
  def reauthenticate
    render_error("Unauthorized", status: :unauthorized) unless cookies[:refresh_token]

    decoded_refresh_token = RefreshToken.find_by(hashed_token: Digest::SHA256.hexdigest(cookies[:refresh_token]))

    if decoded_refresh_token.expired? || decoded_refresh_token.revoked?
      render_error("Unauthorized", status: :unauthorized)
    end

    jwt = JsonWebToken.encode(user_id: decoded_refresh_token.user_id)

    decoded_refresh_token.revoke!

    refresh_token = RefreshToken.create!(user_id: decoded_refresh_token.user_id)

    render_success({ message: "Reauthenticate", jwt: jwt, refresh_token: refresh_token.raw_token })
  end
end
