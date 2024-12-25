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
  encryption_info {
    encryption_in_transit {
      client_broker = "TLS" # Available options: "TLS", "TLS_PLAINTEXT", "PLAINTEXT"
      in_cluster    = true  # Enables encryption between broker nodes
    }
  }

  # client_authentication {
  #   tls {}
  # }

}

