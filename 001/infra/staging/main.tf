terraform {
  backend "s3" {
  }
}

provider "aws" {
  region = "ap-northeast-1"
  assume_role {
    role_arn = var.iam_role_for_terraform
  }
}

module "network" {
  source = "../modules/network"
  tags   = var.tags
}
