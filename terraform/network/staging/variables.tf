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

##########################
# subnet
##########################
variable "public_subnets" {
  type = map(map(string))
  default = {
    public_a = {
      name              = "public-a"
      cidr              = "20.0.1.0/24"
      az                = "ap-northeast-1a"
      nat_gateway_count = 0
    }
    public_c = {
      name              = "public-c"
      cidr              = "20.0.2.0/24"
      az                = "ap-northeast-1c"
      nat_gateway_count = 0
    }
  }
}
variable "private_subnets" {
  type = map(map(string))
  default = {
    private_a = {
      name = "private-a"
      cidr = "20.0.3.0/24"
      az   = "ap-northeast-1a"
    }
    private_c = {
      name = "private-c"
      cidr = "20.0.4.0/24"
      az   = "ap-northeast-1c"
    }
  }
}
variable "secure_subnets" {
  type = map(map(string))
  default = {
    secure_a = {
      name = "secure-a"
      cidr = "20.0.5.0/24"
      az   = "ap-northeast-1a"
    }
    secure_c = {
      name = "secure-c"
      cidr = "20.0.6.0/24"
      az   = "ap-northeast-1c"
    }
  }
}
