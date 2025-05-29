module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_user
    end

    private

    def find_user
      jwt_token = cookies.signed[:jwt]
      reject_unauthorized_connection unless jwt_token

      decoded_jwt = JsonWebToken.decode(jwt_token)
      reject_unauthorized_connection unless decoded_jwt

      user = User.find_by(id: decoded_jwt[:user_id])
      reject_unauthorized_connection unless user

      user
    end
  end
end
