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

module "web" {
  source      = "../modules/web"
  common_tags = var.common_tags
}
