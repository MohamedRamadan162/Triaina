# Role for EKS cluster to manage resources
resource "aws_iam_role" "eks_cluster_role" {
  name = "EKSServiceRole"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })
}

# Attach the policy that lets eks manage resources
resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster_role.name
}

# The EKS cluster
resource "aws_eks_cluster" "triaina_eks_cluster" {
  name     = "triaina-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn
   version  = "1.31.2"

  vpc_config {
    subnet_ids         = var.private_subnet_ids[*]
    security_group_ids = [var.security_group_id]
  }

  depends_on = [aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy]
}


resource "aws_iam_role" "eks_worker_node_role" {
  name = "eks-node-group-eks_worker_node_role"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_role-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_worker_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_role-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_worker_node_role.name
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_role-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_worker_node_role.name
}

# Node group of EC2 instances used by EKS cluster
resource "aws_eks_node_group" "triaina_eks_cluster_worker_node_group" {
  cluster_name    = aws_eks_cluster.triaina_eks_cluster.name
  node_group_name = "triaina_eks_cluster_worker_node_group"
  node_role_arn   = aws_iam_role.eks_worker_node_role.arn

  subnet_ids = var.private_subnet_ids[*]

  capacity_type  = "ON_DEMAND"
  instance_types = ["t2.micro"]

  scaling_config {
    desired_size = 1
    max_size     = 5
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "general"
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_role-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks_worker_node_role-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks_worker_node_role-AmazonEC2ContainerRegistryReadOnly,
  ]
}
