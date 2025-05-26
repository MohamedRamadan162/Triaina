# frozen_string_literal: true

class ApplicationProducer
  include Constants

  def self.publish(topic, payload, extra_params: {})
    message = {
      data: payload.as_json.merge(extra_params)
    }.to_json

    Karafka.producer.produce_async(
      topic: topic,
      payload: message
    )
  rescue => e
    Rails.logger.error("Failed to publish Kafka message to #{topic}: #{e.message}")
    raise
  end
end
