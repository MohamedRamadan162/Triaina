# frozen_string_literal: true

# app/lib/json_web_token.rb
class JsonWebToken
  # secret to encode and decode token
  HMAC_SECRET = ENV.fetch('JWT_SECRET', nil)

  def self.encode(payload)
    # sign token with application secret
    JWT.encode(payload, HMAC_SECRET, algorithm: 'HS256')
  end

  def self.decode(token)
    # get payload; first index in decoded Array
    body = JWT.decode(token, HMAC_SECRET, true, algorithm: 'HS256')[0]
    HashWithIndifferentAccess.new(body)
    # rescue from all decode errors
  rescue JWT::DecodeError => _e
    # raise custom error to be handled by custom handler
    raise(ErrorHandler::AuthenticationError, I18n.t('authentication.suspicious_token'))
  end
end
