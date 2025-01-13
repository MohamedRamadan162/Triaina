resource "aws_elasticache_subnet_group" "triaina_cache_subnet_group" {
  name       = "triaina-cache-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "Triaina Cache Subnet Group"
  }
}

resource "aws_elasticache_replication_group" "triaina_cache" {
  replication_group_id       = "triaina-cache-replication-group"
  description                = "Triaina Redis Cache"
  engine                     = "redis"
  engine_version             = "7.0"
  parameter_group_name       = "default.redis7.0" # Use appropriate parameter group
  node_type                  = "cache.t3.micro"
  num_node_groups            = 1    # Number of shards
  replicas_per_node_group    = 1    # One replica per AZ (you can increase this for more replicas)
  automatic_failover_enabled = true # Enable failover across AZs
  port                       = 6379
  transit_encryption_enabled = true # Enable encryption in transit
  at_rest_encryption_enabled = true # Enable encryption at rest

  subnet_group_name  = aws_elasticache_subnet_group.triaina_cache_subnet_group.name
  security_group_ids = toset([var.elasticache_security_group_id])

  tags = {
    Name = "Triaina Cache Cluster"
  }
}
