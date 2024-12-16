variable "region" {
  description = "AWS Region"
  type        = string
}

variable "db_username" {
  description = "DB Username"
  type        = string
}

variable "db_password" {
  description = "DB Password"
  type        = string
  sensitive   = true
}

# For later use
# variable "cache_password" {
#   description = "Cache Password"
#   type        = string
#   sensitive   = true
# }
