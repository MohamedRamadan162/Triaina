output "users_db_instance_identifier" {
  description = "The RDS instance identifier"
  value       = aws_db_instance.users.id
}

output "users_db_endpoint" {
  description = "The endpoint and port the users db"
  value       = aws_db_instance.users.endpoint
}
