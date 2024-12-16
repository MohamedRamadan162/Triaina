resource "aws_elasticache_cluster" "triaina-cache" {
  cluster_id           = "triaina-cache"
  engine               = "redis"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis7"
  engine_version       = "7.0"
  apply_immediately    = true
  port                 = 6379

  subnet_group_name  = var.private_subnet_group_name
  security_group_ids = [var.elasticache_security_group_id]
}
