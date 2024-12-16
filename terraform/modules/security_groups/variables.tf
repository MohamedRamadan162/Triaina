variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "private_subnet_cidr_blocks" {
  description = "Private subnets CIDR blocks"
  type        = list(string)
}