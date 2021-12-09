variable "common_tags" { type = map(string) }
variable "vpc_id" {}

##########################
# Launch Template
##########################
variable "ami_id" {}
variable "instance_type" {}
variable "key_name" {}
variable "cluster_name" {}
