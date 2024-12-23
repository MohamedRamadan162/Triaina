require "aws-sdk-rds"

# Method to fetch the RDS endpoint
def fetch_rds_endpoint
  if Rails.env.production?
    client = Aws::RDS::Client.new(region: ENV["AWS_REGION"])
  else
      client = Aws::RDS::Client.new(
      endpoint: ENV["AWS_ENDPOINT"],
      region: ENV["AWS_REGION"],
      access_key_id: "test",
      secret_access_key: "test",
      ssl_verify_peer: false
    )
  end
  response = client.describe_db_instances(db_instance_identifier: ENV["AWS_RDS_IDENTIFIER"])
  ENV["RDS_HOST"] = response.db_instances.first.endpoint.address.to_s
  ENV["RDS_PORT"]= response.db_instances.first.endpoint.port.to_s
rescue Aws::RDS::Errors::DBInstanceNotFound => e
  Rails.logger.error "RDS instance not found: #{e.message}"
  raise
rescue StandardError => e
  Rails.logger.error "Failed to fetch RDS endpoint: #{e.message}"
  raise
end

# Set the fetched endpoint as an environment variable
fetch_rds_endpoint
Rails.logger.info "RDS Endpoint set to: #{ENV['RDS_ENDPOINT']}"
