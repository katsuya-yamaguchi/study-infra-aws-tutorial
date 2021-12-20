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
  source                             = "../modules/web"
  common_tags                        = var.common_tags
  vpc_id                             = data.terraform_remote_state.network.outputs.vpc_id
  ami_id                             = var.ami_id
  instance_type                      = var.instance_type
  key_name                           = var.key_name
  cluster_name                       = var.cluster_name
  az                                 = var.az
  public_subnets_id                  = data.terraform_remote_state.network.outputs.public_subnets_id
  s3_logging_bucket                  = module.common.s3_logging_bucket
  ssl_certificate_study_infra_tk_arn = module.common.ssl_certificate_study_infra_tk_arn
}

module "common" {
  source         = "../modules/common"
  logging_bucket = var.logging_bucket
}
