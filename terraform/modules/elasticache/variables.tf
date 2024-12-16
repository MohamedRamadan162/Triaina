variable "elasticache_security_group_id" {
  description = "Elasticache security group id"
  type        = string
}

# For later use
# variable "cache_password" {
#   description = "Cache password"
#   type        = string
#   sensitive   = true
# }

variable "private_subnet_group_name" {
  description = "Privates subnets group name"
  type        = string
}
