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

data "terraform_remote_state" "network" {
  backend = "s3"
  config  = var.network_remote_state_config
}

module "web" {
  source      = "../modules/web"
  common_tags = var.common_tags
  vpc_id      = data.terraform_remote_state.network.outputs.vpc_id
}
