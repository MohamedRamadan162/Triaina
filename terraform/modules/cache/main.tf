resource "aws_db_subnet_group" "triaina_cache_subnet_group" {
  name       = "triaina-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "Triaina DB Subnet Group"
  }
}

resource "aws_elasticache_cluster" "triaina-cache" {
  cluster_id                 = "triaina-cache"
  engine                     = "redis"
  node_type                  = "cache.t3.micro"
  num_cache_nodes            = 1
  parameter_group_name       = "default.redis7"
  engine_version             = "7.0"
  apply_immediately          = true
  port                       = 6379
  transit_encryption_enabled = true # Enable in-transit encryption

  subnet_group_name  = aws_db_subnet_group.triaina_cache_subnet_group.name
  security_group_ids = toset([var.elasticache_security_group_id])
}
