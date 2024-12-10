# variable "private_subnet_ids" {
#   description = "Private subnets CIDR blocks"
#   type        = list(string)
# }

variable "elasticache_security_group_id" {
  description = "Elasticache security group id"
  type        = string
}
