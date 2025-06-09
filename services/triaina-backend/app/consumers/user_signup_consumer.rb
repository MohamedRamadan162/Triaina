class UserSignupConsumer < ApplicationConsumer
  # This consumer listens to the 'user_signup' topic and processes user signup events.
  def consume
    messages.each do |msg|
      data = msg.payload["data"]
      user = User.find_by(id: data["id"])
      UserMailer.welcome_email(user).deliver_now if user
    end
  end
end
