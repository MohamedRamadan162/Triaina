module ApplicationCable
  class Channel < ActionCable::Channel::Base
    before_subscribe :authenticate_user!

    private

    def authenticate_user!
      reject unless connection.current_user
    end
  end
end
