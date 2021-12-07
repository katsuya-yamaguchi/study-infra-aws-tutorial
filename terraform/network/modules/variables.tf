variable "common_tags" { type = map(string) }
variable "public_subnets" { type = map(map(string)) }
variable "private_subnets" { type = map(map(string)) }
variable "secure_subnets" { type = map(map(string)) }
