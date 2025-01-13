resource "aws_msk_cluster" "triaina_msk" {
  cluster_name  = "triaina-msk-cluster"
  kafka_version = "3.7"

  number_of_broker_nodes = 3

  broker_node_group_info {
    instance_type   = "kafka.t3.small"
    client_subnets  = var.private_subnet_ids
    security_groups = [var.msk_security_group_id]

    storage_info {
      ebs_storage_info {
        volume_size = 20
      }
    }
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

  configuration_info {
    arn      = aws_msk_configuration.triaina_msk_configuration.arn
    revision = aws_msk_configuration.triaina_msk_configuration.latest_revision
  }

}

resource "aws_msk_configuration" "triaina_msk_configuration" {
  name              = "triaina-msk-configuration"
  kafka_versions    = ["3.7"]
  server_properties = <<EOF
auto.create.topics.enable = true
delete.topic.enable = true
num.partitions = 3
default.replication.factor = 3
EOF
}
