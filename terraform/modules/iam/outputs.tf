output "eks-role-arn" {
  description = "Role for EKS cluster services workers"
  value       = aws_iam_role.eks_role.arn
}
