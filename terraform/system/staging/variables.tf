variable "iam_role_for_terraform" {}
variable "network_remote_state_config" {}

variable "common_tags" {
  type = map(string)
  default = {
    Env    = "staging"
    System = "study-infra-tutorial"
  }
}

##########################
# Launch Template
##########################
variable "ami_id" {
  type        = string
  default     = "ami-0a428a8bcfce0f804"
  description = "パラメータストアから取得した2021/11/25時点のAMI。https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/ecs-optimized_AMI.html"
}
variable "instance_type" {
  type    = string
  default = "t3.nano"
}
variable "key_name" {
  type    = string
  default = "ecs-container-stg"
}
variable "cluster_name" {
  type    = string
  default = "study-infra-web"
}
