terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.4.0 "
    }
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source = "./modules/vpc"
  
  region         = var.region
  vpc_cidr       = var.vpc_cidr
  public_subnets = var.public_subnets
  cluster_name   = var.cluster_name
}

module "eks" {
  source = "./modules/eks"
  
  cluster_name      = var.cluster_name
  cluster_version   = var.cluster_version
  public_subnet_ids = module.vpc.public_subnet_ids
  
  depends_on = [module.vpc]
}