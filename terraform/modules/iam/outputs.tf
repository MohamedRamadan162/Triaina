output "eks-role-arn" {
  description = "Role for EKS cluster  workers"
  value       = aws_iam_role.eks_role.arn
}

output "eks-worker-role-arn" {
  description = "Role for EKS worker nodes"
  value       = aws_iam_role.eks_worker_role.arn
}
