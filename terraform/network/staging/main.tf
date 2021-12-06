terraform {
  backend "s3" {
  }
}

provider "aws" {
  region = "ap-northeast-1"
  assume_role {
    role_arn = var.iam_role_for_terraform
  }
  default_tags {
    tags = var.common_tags
  }
}

module "network" {
  source          = "../modules"
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  secure_subnets  = var.secure_subnets
  common_tags     = var.common_tags
}
