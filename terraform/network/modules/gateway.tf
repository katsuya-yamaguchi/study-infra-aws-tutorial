##########################
# Internet Gateway
##########################
resource "aws_internet_gateway" "study_infra" {
  vpc_id = aws_vpc.study_infra.id
  tags = {
    Name = var.common_tags["System"]
  }
}

##########################
# EIP
##########################
resource "aws_eip" "nat_gateway_public_a" {
  count = abs(var.public_subnets.public_a["nat_gateway_count"]) == 0 ? 0 : 1

  vpc = true
  tags = {
    Name = var.public_subnets.public_a["name"]
  }
}

resource "aws_eip" "nat_gateway_public_c" {
  count = abs(var.public_subnets.public_c["nat_gateway_count"]) == 0 ? 0 : 1

  vpc = true
  tags = {
    Name = var.public_subnets.public_c["name"]
  }
}

##########################
# NAT Gateway
##########################
resource "aws_nat_gateway" "public_a" {
  count = abs(var.public_subnets.public_a["nat_gateway_count"]) == 0 ? 0 : 1

  allocation_id     = aws_eip.nat_gateway_public_a[0].id
  connectivity_type = "public"
  subnet_id         = aws_subnet.public["public_a"].id
  tags = {
    Name = var.public_subnets.public_a["name"]
  }
}

resource "aws_nat_gateway" "public_c" {
  count = abs(var.public_subnets.public_c["nat_gateway_count"]) == 0 ? 0 : 1

  allocation_id     = aws_eip.nat_gateway_public_c[0].id
  connectivity_type = "public"
  subnet_id         = aws_subnet.public["public_c"].id
  tags = {
    Name = var.public_subnets.public_c["name"]
  }
}
