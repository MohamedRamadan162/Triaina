# frozen_string_literal: true

module UserEventProducer
  include KafkaEventProducer
  include Constants

  def self.publish_create_user(user)
    publish_event("user.created", user)
  end

  def self.publish_delete_user(user)
    publish_event("user.deleted", user)
  end

  def self.publish_update_user(user)
    publish_event("user.updated", user)
  end

  def self.publish_sign_up(user)
    publish_event("user.signed_up", user)
  end

  def self.publish_event(event_name, user, extra_params: {})
    payload = {
      id: user.id,
      email: user.email,
      created_at: user.created_at,
      updated_at: user.updated_at,
      event_version: KAFKA_EVENT_VERSION,
      timestamp: Time.now.utc
    }.merge(extra_params)

    KafkaEventProducer.publish(event_name, payload)
  end
end
