resource "aws_msk_cluster" "triaina_msk" {
  cluster_name  = "triaina-msk-cluster"
  kafka_version = "3.6.1"

  number_of_broker_nodes = 3
  enhanced_monitoring    = "PER_TOPIC_PER_PARTITION" # Monitoring level

  broker_node_group_info {
    instance_type   = "kafka.t3.small"
    client_subnets  = var.private_subnet_ids
    security_groups = [var.msk_security_group_id]
  }

  configuration_info {
    arn      = aws_msk_configuration.kafka_config.arn
    revision = aws_msk_configuration.kafka_config.latest_revision
  }
  
  ## This is initial the rest of the config should follow as soon as it is more clear as the project matures
}

resource "aws_msk_configuration" "kafka_config" {
  name              = "kafka-config"
  kafka_versions    = ["3.6.1"]
  server_properties = <<PROPERTIES
# Default Kafka port
port=9092
# TLS port
ssl.port=9094
# SASL port
sasl.port=9096
# Inter-broker communication port
inter.broker.listener.name=INTERNAL
inter.broker.port=9093
PROPERTIES
}
