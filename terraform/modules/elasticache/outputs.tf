output "elasticache_cluster_id" {
  description = "The ID of the ElastiCache cluster"
  value       = aws_elasticache_cluster.triaina-cache.cluster_id
}

output "elasticache_cluster_endpoint" {
  description = "The endpoint and port of the ElastiCache cluster"
  value       = aws_elasticache_cluster.triaina-cache.configuration_endpoint
}

