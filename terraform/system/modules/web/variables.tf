variable "common_tags" { type = map(string) }
variable "vpc_id" {}
variable "public_subnets_id" { type = list(string) }

##########################
# Launch Template
##########################
variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "cluster_name" {}

##########################
# ASG
##########################
variable "az" { type = list(any) }

##########################
# S3
##########################
variable "s3_logging_bucket" {}


##########################
# ACM
##########################
variable "ssl_certificate_study_infra_tk_arn" {}
