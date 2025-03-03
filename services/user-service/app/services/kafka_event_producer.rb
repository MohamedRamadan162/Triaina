# frozen_string_literal: true

module KafkaEventProducer
  def self.publish(topic, payload)
    message = {
      data: payload
    }.to_json

    Karafka.producer.produce_async(
      topic: topic,
      payload: message
    )
  end
end
