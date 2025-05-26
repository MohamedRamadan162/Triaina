# frozen_string_literal: true

class UserEventProducer < ApplicationProducer
  def self.publish_create_user(user)
    self.publish("user.created", user)
  end

  def self.publish_delete_user(user)
    self.publish("user.deleted", user)
  end

  def self.publish_update_user(user)
    self.publish("user.updated", user)
  end

  def self.publish_sign_up(user)
    self.publish("user.signed_up", user)
  end
end
