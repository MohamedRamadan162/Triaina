output "rds_security_group_id" {
  description = "The ID of the RDS security group"
  value       = aws_security_group.rds_sg.id
}

output "elasticache_security_group_id" {
  description = "The ID of the Redis ElastiCache security group"
  value       = aws_security_group.elasticache_sg.id
}
