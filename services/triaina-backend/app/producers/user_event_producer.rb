# frozen_string_literal: true

class UserEventProducer < ApplicationProducer
  def self.publish_create_user(user)
    self.publish("user_created", user)
  end

  def self.publish_delete_user(user)
    self.publish("user_deleted", user)
  end

  def self.publish_update_user(user)
    self.publish("user_updated", user)
  end

  def self.publish_sign_up(user)
    self.publish("user_signed_up", user)
  end
end
