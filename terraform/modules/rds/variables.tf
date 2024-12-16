variable "db_username" {
  description = "User DB Username"
  type        = string
}

variable "db_password" {
  description = "User DB Password"
  type        = string
  sensitive   = true
}

variable "private_subnet_ids" {
  description = "Private subnets CIDR blocks"
  type        = list(string)
}

variable "private_subnet_group_name" {
  description = "Privates subnets group name"
  type        = string
}

variable "rds_security_group_id" {
  description = "RDS security group id"
  type        = string
}
