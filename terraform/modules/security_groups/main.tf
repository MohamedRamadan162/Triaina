resource "aws_security_group" "rds_sg" {
  name        = "rds-security-group"
  description = "Allow access to RDS PostgreSQL DB"
  vpc_id      = var.vpc_id

  # Allow inbound traffic from within the VPC
  ingress {
    from_port   = 5432 # PostgreSQL default port
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_cidr_blocks
  }

  # Allow outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "DB Security Group"
  }
}

resource "aws_security_group" "elasticache_sg" {
  name        = "elasticache-security-group"
  description = "Allow access to Redis ElastiCache Cluster"
  vpc_id      = var.vpc_id

  # Allow inbound traffic from within the VPC
  ingress {
    from_port   = 6379 # Redis default port
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_cidr_blocks
  }

  # Allow outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.private_subnet_cidr_blocks
  }

  tags = {
    Name = "Cache Security Group"
  }
}

resource "aws_security_group" "eks_sec_group" {
  name        = "eks-sec-group"
  description = "EKS security group"
  vpc_id      = var.vpc_id

  # Allow inbound traffic from within the VPC
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_cidr_blocks
  }

  # Allow outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.private_subnet_cidr_blocks
  }

  tags = {
    Name = "EKS Security Group"
  }
}

resource "aws_security_group" "msk_sec_group" {
  name        = "msk_sec_group"
  description = "MSK security group"
  vpc_id      = var.vpc_id

  # Allow inbound traffic from within the VPC
  ingress {
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_cidr_blocks
  }
  # Allow inbound traffic from within the VPC
  ingress {
    from_port   = 4511
    to_port     = 4511
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_cidr_blocks
  }

  # Allow communication between brokers (port 9093) if necessary (for multiple brokers)
  ingress {
    from_port   = 9093
    to_port     = 9093
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_cidr_blocks
  }
  ingress {
    from_port   = 4510
    to_port     = 4510
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_cidr_blocks
  }


  # Allow outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.private_subnet_cidr_blocks
  }

  tags = {
    Name = "MSK Security Group"
  }

}
