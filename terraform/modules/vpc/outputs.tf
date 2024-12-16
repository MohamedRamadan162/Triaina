output "vpc_arn" {
  description = "The ARN of the created VPC"
  value       = aws_vpc.triaina.arn
}

output "vpc_id" {
  description = "The ID of the created VPC"
  value       = aws_vpc.triaina.id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = aws_subnet.public_subnets[*].id
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = aws_subnet.private_subnets[*].id
}

output "public_route_table_subnet_cidr_blocks" {
  description = "CIDR blocks of the private subnet"
  value       = var.public_subnet_cidrs
}

output "private_subnet_cidr_blocks" {
  description = "CIDR blocks of the private subnet"
  value       = var.private_subnet_cidrs
}

output "private_subnet_group_name" {
  description = "Private subnet group"
  value       = aws_db_subnet_group.private_subnet_group.name

}
