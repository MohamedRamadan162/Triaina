variable "private_subnet_ids" {
  description = "Private subnets CIDR blocks"
  type        = list(string)
}

variable "msk_security_group_id" {
  description = "MSK security group id"
  type        = string
}
