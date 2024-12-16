output "eks_cluster_arn" {
  description = "Triaina EKS cluster ARN"
  value       = aws_eks_cluster.triaina_eks_cluster.arn
}
