resource "aws_eks_cluster" "triaina-eks-cluster" {
  name     = "triaina-eks-cluster"
  role_arn = var.eks-worker-role-arn

  vpc_config {
    subnet_ids         = var.private-subnet-ids[*]
    security_group_ids = [var.security-group-id]
  }
}
