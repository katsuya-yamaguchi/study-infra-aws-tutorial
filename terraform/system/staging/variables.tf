variable "iam_role_for_terraform" {
  default = "arn:aws:iam::XXXXXXXXXXX:role/study-infra-terraform-role"
}

variable "common_tags" {
  type = map(string)
  default = {
    Env    = "staging"
    System = "study-infra-tutorial"
  }
}

variable "network_remote_state_config" {
  type = map(string)
  default = {
    bucket   = "terraform-state-develop-0001"
    key      = "study-infra-tutorial/staging.tfstate"
    region   = "ap-northeast-1"
    role_arn = "arn:aws:iam::XXXXXXXXXXX:role/study-infra-terraform-role"
  }
}
