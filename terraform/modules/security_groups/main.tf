resource "aws_security_group" "rds_security_group" {
  name_prefix        = "rds-security-group-"
  description = "Security group for RDS PostgreSQL"
  vpc_id      = var.vpc_id

  # Allow inbound traffic from within the VPC
  ingress {
    description = "PostgreSQL access from private subnets"
    from_port   = 5432 # PostgreSQL default port
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_cidr_blocks
  }

  # Allow outbound traffic
  egress {
    description = "HTTPS access from private subnets"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DB Security Group"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "elasticache_security_group" {
  name_prefix        = "elasticache-security-group-"
  description = "Security group for Redis ElastiCache"
  vpc_id      = var.vpc_id

  # Allow inbound traffic from within the VPC
  ingress {
    description = "Redis access from private subnets"
    from_port   = 6379 # Redis default port
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_cidr_blocks
  }

  # Allow outbound traffic
  egress {
    description = "Allow outbound to private subnets"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.private_subnet_cidr_blocks
  }

  tags = {
    Name = "Cache Security Group"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "eks_security_group" {
  name_prefix        = "eks-sec-group-"
  description = "Security group for EKS cluster"
  vpc_id      = var.vpc_id

  # Allow inbound traffic from within the VPC
  ingress {
    description = "HTTPS access from private subnets"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_cidr_blocks
  }

  # Allow outbound traffic
  egress {
    description = "Allow outbound to private subnets"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.private_subnet_cidr_blocks
  }

  tags = {
    Name = "EKS Security Group"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "msk_security_group" {
  name_prefix        = "msk_sec_group-"
  description = "Security group for MSK cluster"
  vpc_id      = var.vpc_id

  # Allow inbound traffic from within the VPC
  ingress {
    description = "Kafka broker access"
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_cidr_blocks
  }

  # Allow communication between brokers (port 9093) if necessary (for multiple brokers)
  ingress {
    description = "Inter-broker communication"
    from_port   = 9093
    to_port     = 9093
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_cidr_blocks
  }

  # Allow outbound traffic
  egress {
    description = "Allow outbound to private subnets"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.private_subnet_cidr_blocks
  }

  tags = {
    Name = "MSK Security Group"
  }
  
  lifecycle {
    create_before_destroy = true
  }
}
