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

  cidr_block           = "10.0.0.0/16"
  vpc_name             = "Triaina VPC"
  azs                  = ["eu-west-3a", "eu-west-3b", "eu-west-3c"]
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnet_cidrs = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  gateway_name         = "Triaina Public IG"
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}
