output "eks-cluster-arn" {
  description = "Triaina EKS cluster ARN"
  value       = aws_eks_cluster.triaina-eks-cluster.arn
}
