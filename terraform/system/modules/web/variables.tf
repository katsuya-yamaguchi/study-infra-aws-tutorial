variable "common_tags" { type = map(string) }
variable "vpc_id" {}

##########################
# Launch Template
##########################
variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "cluster_name" {}

##########################
# S3
##########################
variable "s3_logging_bucket" {}


##########################
# ACM
##########################
variable "ssl_certificate_study_infra_tk_arn" {}
