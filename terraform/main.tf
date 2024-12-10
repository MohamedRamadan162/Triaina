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
