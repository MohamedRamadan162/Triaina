resource "aws_iam_policy" "s3_access_policy" {
  name        = "S3BucketAccessPolicy"
  description = "Policy to allow access to the S3 bucket"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket",                 # For listing objects in the bucket
          "s3:ListBucketMultipartUploads", # For listing multipart uploads
          "s3:AbortMultipartUpload"        # For aborting multipart uploads
        ]
        Resource = [for arn in var.s3-arns : "${arn}/*"]
      }
    ]
  })
}

resource "aws_iam_policy" "rds_access_policy" {
  name        = "RDSAccessPolicy"
  description = "Policy to allow access to RDS"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["rds:DescribeDBInstances", "rds:Connect"]
        Resource = [for arn in var.rds-arns : "${arn}/*"]
      }
    ]
  })
}

resource "aws_iam_policy" "elasticache_access_policy" {
  name        = "ElastiCacheAccessPolicy"
  description = "Policy to allow access to ElastiCache"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["elasticache:DescribeCacheClusters", "elasticache:Connect"]
        Resource = [for arn in var.elasticache-arns : "${arn}/*"]
      }
    ]
  })
}

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

resource "aws_iam_role_policy_attachment" "s3_policy_attachment" {
  policy_arn = aws_iam_policy.s3_access_policy.arn
  role       = aws_iam_role.eks_role.name
}

resource "aws_iam_role_policy_attachment" "rds_policy_attachment" {
  policy_arn = aws_iam_policy.rds_access_policy.arn
  role       = aws_iam_role.eks_role.name
}

resource "aws_iam_role_policy_attachment" "elasticache_policy_attachment" {
  policy_arn = aws_iam_policy.elasticache_access_policy.arn
  role       = aws_iam_role.eks_role.name
}

