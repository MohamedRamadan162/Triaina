variable "cidr_block" {
  type        = string
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "vpc_name" {
  type        = string
  description = "Name of the VPC"
  default     = "Triaina VPC"
}

variable "azs" {
  type        = list(string)
  description = "List of availability zones"
  default     = ["eu-west-3a", "eu-west-3b", "eu-west-3c"]
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "gateway_name" {
  type        = string
  description = "Name of the Internet Gateway"
  default     = "Triaina Public IG"
}
