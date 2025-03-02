# frozen_string_literal: true

module UserEventProducer
  include KafkaEventProducer
  include Constants

  def self.publish_create_user(user)
    publish_event('user_created', user)
  end

  def self.publish_delete_user(user)
    publish_event('user_deleted', user)
  end

  def self.publish_update_user(user)
    publish_event('user_updated', user)
  end

  def self.publish_event(event_name, user)
    payload = {
      id: user.id,
      email: user.email,
      created_at: user.created_at,
      updated_at: user.updated_at,
      event_version: KAFKA_EVENT_VERSION,
      timestamp: Time.now.utc
    }.to_json

    KafkaEventProducer.publish(event_name, payload)
  end
end
