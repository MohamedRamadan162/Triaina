require "aws-sdk-elasticache"

# Method to fetch the Redis endpoint from ElastiCache
def fetch_redis_endpoint
  if Rails.env.production?
    client = Aws::ElastiCache::Client.new(region: ENV["AWS_REGION"])
  else
    client = Aws::ElastiCache::Client.new(
      endpoint: ENV["AWS_ENDPOINT"],
      region: ENV["AWS_REGION"],
      access_key_id: "test",
      secret_access_key: "test",
      ssl_verify_peer: false
    )
  end

  # Describe cache clusters and get the endpoint
  response = client.describe_cache_clusters({ cache_cluster_id: ENV["AWS_REDIS_CLUSTER_ID"], show_cache_node_info: true })

  # Get the Redis endpoint (configuration_endpoint contains host and port)
  ENV["REDIS_ENDPOINT"] = "#{response.cache_clusters.first.configuration_endpoint.address}:#{response.cache_clusters.first.configuration_endpoint.port}"

rescue Aws::ElastiCache::Errors::CacheClusterNotFound => e
  Rails.logger.error "Redis cluster not found: #{e.message}"
  raise
rescue StandardError => e
  Rails.logger.error "Failed to fetch Redis endpoint: #{e.message}"
  raise
end

# Set the fetched endpoint as an environment variable
fetch_redis_endpoint
Rails.logger.info "Redis Endpoint set to: #{ENV['REDIS_ENDPOINT']}:#{ENV['REDIS_PORT']}"
