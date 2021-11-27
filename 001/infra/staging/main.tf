terraform {
  backend "s3" {
  }
}

provider "aws" {
  region = "ap-northeast-1"
  assume_role {
    role_arn = var.sts_iam_role
  }
}

module "network" {
  source = "../modules/network"
  tags   = var.tags
}
