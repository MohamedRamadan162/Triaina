output "rds_security_group_id" {
  description = "The ID of the RDS security group"
  value       = aws_security_group.rds_security_group.id
}

output "elasticache_security_group_id" {
  description = "The ID of the Redis ElastiCache security group"
  value       = aws_security_group.elasticache_security_group.id
}

output "eks_security_group_id" {
  description = "The ID of the EKS cluster security group"
  value       = aws_security_group.eks_security_group.id
}

output "msk_security_group_id" {
  description = "The ID of the MSK cluster security group"
  value       = aws_security_group.msk_security_group.id
}
