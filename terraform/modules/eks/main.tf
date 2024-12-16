resource "aws_iam_role" "eks_role" {
  name = "EKSServiceRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "sts:AssumeRole"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_eks_cluster" "triaina_eks_cluster" {
  name     = "triaina-eks-cluster"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    subnet_ids         = var.private_subnet_ids[*]
    security_group_ids = [var.security_group_id]
  }
}
