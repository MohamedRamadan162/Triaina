variable "eks-role-arn" {
  description = "The ARN of the EKS role"
  type        = string
}

variable "private-subnet-ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "security-group-id" {
  description = "The security group ID for EKS"
  type        = string
}
