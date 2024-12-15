provider "aws" {
  region = "eu-west-3"
  default_tags {
    tags = {
      Application = "triaina"
    }
  }
}

module "vpc" {
  source = "./modules/vpc"
}

module "security_groups" {
  source                     = "./modules/security-groups"
  vpc_id                     = module.vpc.vpc_id
  private_subnet_cidr_blocks = module.vpc.private_subnet_cidr_blocks
}

module "rds" {
  source                = "./modules/rds"
  private_subnet_ids    = module.vpc.private_subnet_ids
  rds_security_group_id = module.security_groups.rds_security_group_id
  user_db_username      = var.user_db_username
  user_db_password      = var.user_db_password
}

module "elasticache" {
  source                        = "./modules/elasticache"
  elasticache_security_group_id = module.security_groups.elasticache_security_group_id
}

module "s3-buckets" {
  source = "./modules/s3-buckets"
}

module "iam" {
  source           = "./modules/iam"
  s3-arns          = [module.s3-buckets.s3_course_content_bucket_arn, module.s3-buckets.s3_course_content_bucket_arn]
  rds-arns         = [module.rds.rds_instance_arn]
  elasticache-arns = [module.elasticache.elasticache_cluster_arn]
}

module "eks" {
  source              = "./modules/eks"
  eks-role-arn        = module.iam.eks-role-arn
  eks-worker-role-arn = module.iam.eks-worker-role-arn
  private-subnet-ids  = module.vpc.private_subnet_ids
  security-group-id   = module.security_groups.eks_security_group_id
}
