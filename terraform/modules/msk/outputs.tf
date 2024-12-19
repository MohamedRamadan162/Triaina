output "msk_cluster_arn" {
  value = aws_msk_cluster.triaina_msk.arn
}

output "msk_cluster_bootstrap_brokers" {
  value = aws_msk_cluster.triaina_msk.bootstrap_brokers
}
