resource "aws_security_group" "rds_security_group" {
  name_prefix = "rds-security-group-"
  description = "Security group for RDS PostgreSQL"
  vpc_id      = var.vpc_id

  # Allow from private subnet CIDRs
  ingress {
    description = "PostgreSQL access from private subnets"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow from EKS nodes
  ingress {
    description     = "PostgreSQL access from EKS nodes"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_security_group.id]
  }

  # Allow all outbound traffic
  egress {
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
  name_prefix = "elasticache-security-group-"
  description = "Security group for Redis ElastiCache"
  vpc_id      = var.vpc_id

  # Allow from private subnet CIDRs
  ingress {
    description = "Redis access from private subnets"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow from EKS nodes
  ingress {
    description     = "Redis access from EKS nodes"
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_security_group.id]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Cache Security Group"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "eks_security_group" {
  name_prefix = "eks-sec-group-"
  description = "Security group for EKS cluster"
  vpc_id      = var.vpc_id

  # Allow HTTPS from private subnets (e.g., kube-api access)
  ingress {
    description = "HTTPS access from private subnets"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_cidr_blocks
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "EKS Security Group"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "msk_security_group" {
  name_prefix = "msk-sec-group-"
  description = "Security group for MSK cluster"
  vpc_id      = var.vpc_id

  # Kafka broker access from private subnets
  ingress {
    description = "Kafka access from private subnets"
    from_port   = 9092
    to_port     = 9092
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_cidr_blocks
  }

  # Kafka broker access from EKS nodes
  ingress {
    description     = "Kafka access from EKS nodes"
    from_port       = 9092
    to_port         = 9092
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_security_group.id]
  }

  # Inter-broker communication (optional for MSK clusters)
  ingress {
    description = "Inter-broker communication"
    from_port   = 9093
    to_port     = 9093
    protocol    = "tcp"
    cidr_blocks = var.private_subnet_cidr_blocks
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "MSK Security Group"
  }

  lifecycle {
    create_before_destroy = true
  }
}
