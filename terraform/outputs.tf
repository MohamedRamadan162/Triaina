output "users_db_endpoint" {
  description = "endpoint and port of the users db"
  value       = module.rds.users_db_endpoint
}

output "elasticache_cluster_endpoint" {
  description = "The endpoint and port of the ElastiCache cluster"
  value       = module.elasticache.elasticache_cluster_endpoint
}

output "user-content-bucket-domain-name" {
  value       = module.s3-buckets.user-content-bucket-domain-name
  description = "The regional domain name for the Users' data S3 bucket"
}

output "course-content-bucket-domain-name" {
  value       = module.s3-buckets.course-content-bucket-domain-name
  description = "The regional domain name for the Courses' data S3 bucket"
}
