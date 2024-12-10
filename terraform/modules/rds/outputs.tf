output "db_instance_identifier" {
  description = "The RDS instance identifier"
  value       = aws_db_instance.user.id
}

output "db_endpoint" {
  description = "The RDS instance endpoint"
  value       = aws_db_instance.user.endpoint
}

output "db_port" {
  description = "The port the RDS instance is listening on"
  value       = aws_db_instance.user.port
}
