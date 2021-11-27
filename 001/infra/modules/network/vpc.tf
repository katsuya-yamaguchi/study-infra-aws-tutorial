resource "aws_vpc" "study_infra" {
  cidr_block = "20.0.0.0/16"
  tags = {
    "Env"    = var.tags["Env"]
    "System" = var.tags["System"]
  }
}
