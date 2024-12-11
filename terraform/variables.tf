# variable "aws_region" {
#   description = "The region of triaina app"
#   type        = string
# }

variable "user_db_username" {
  description = "User DB Username"
  type        = string
}

variable "user_db_password" {
  description = "User DB Password"
  type        = string
  sensitive   = true
}
