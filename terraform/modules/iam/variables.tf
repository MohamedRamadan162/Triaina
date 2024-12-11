variable "s3-arns" {
  description = "List of ARNs for S3 Buckets"
  type        = list(string)
  default     = []
}
variable "elasticache-arns" {
  description = "List of ARNs for ElastiCache"
  type        = list(string)
  default     = []
}
variable "rds-arns" {
  description = "List of ARNs for RDS"
  type        = list(string)
  default     = []
}
