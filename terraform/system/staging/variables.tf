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
