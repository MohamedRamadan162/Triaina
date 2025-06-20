terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.region

  ## Tag for all AWS components
  default_tags {
    tags = {
      Application = "Triaina"
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  }
}

## All available zones in the region
data "aws_availability_zones" "available_zones" {}

## VPC Module
module "vpc" {
  source = "./modules/vpc"
  # only 2 AZs 
  availability_zones = slice(data.aws_availability_zones.available_zones.names, 0, 3)
}

## All security groups
module "security_groups" {
  source                     = "./modules/security_groups"
  vpc_id                     = module.vpc.vpc_id
  private_subnet_cidr_blocks = module.vpc.private_subnet_cidr_blocks
}

## S3 Buckets
module "s3-buckets" {
  source = "./modules/s3_buckets"
}

## All relational DBs
module "rds" {
  source                = "./modules/database"
  private_subnet_ids    = module.vpc.private_subnet_ids
  rds_security_group_id = module.security_groups.rds_security_group_id
  db_username           = var.db_username
  db_password           = var.db_password

  depends_on = [module.security_groups]
}

## Cache cluster
module "elasticache" {
  source                        = "./modules/cache"
  elasticache_security_group_id = module.security_groups.elasticache_security_group_id
  private_subnet_ids            = module.vpc.private_subnet_ids

  depends_on = [module.security_groups]

}

## EKS cluster
module "eks" {
  source             = "./modules/kubernetes"
  private_subnet_ids = module.vpc.private_subnet_ids
  security_group_id  = module.security_groups.eks_security_group_id

  depends_on = [module.security_groups]
}

## MSK cluster
module "msk" {
  source                = "./modules/kafka"
  private_subnet_ids    = module.vpc.private_subnet_ids
  msk_security_group_id = module.security_groups.msk_security_group_id

  depends_on = [module.security_groups]
}
