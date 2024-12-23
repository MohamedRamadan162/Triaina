require "aws-sdk-kafka"

# Method to fetch the Kafka endpoint
def fetch_kafka_endpoint
  if Rails.env.production?
    client = Aws::Kafka::Client.new(region: ENV["AWS_REGION"])
  else
    client = Aws::Kafka::Client.new(
      endpoint: ENV["AWS_ENDPOINT"],
      region: ENV["AWS_REGION"],
      access_key_id: "test",
      secret_access_key: "test",
      ssl_verify_peer: false
    )
  end

  # List all clusters (this will fetch your Kafka cluster details)
  clusters_response = client.list_clusters({ max_results: 1 })

  # Get the bootstrap brokers (Kafka brokers)
  brokers_response = client.get_bootstrap_brokers({ cluster_arn: clusters_response.cluster_info_list[0].cluster_arn })

  # You can access the broker list here
  brokers = brokers_response.bootstrap_broker_string

  # Set the brokers as an environment variable for your application
  ENV["KAFKA_BROKER_ENDPOINT"] = brokers
rescue Aws::Kafka::Errors::ServiceError => e
  Rails.logger.error "Error fetching Kafka brokers: #{e.message}"
  raise
end

# Call the method to fetch the Kafka endpoint
fetch_kafka_endpoint
Rails.logger.info "Kafka Endpoint set to: #{ENV['KAFKA_BROKER_ENDPOINT']}"
