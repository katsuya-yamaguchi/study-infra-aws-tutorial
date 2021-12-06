resource "aws_subnet" "public" {
  for_each          = var.public_subnets
  vpc_id            = aws_vpc.study_infra.id
  availability_zone = each.value.az
  cidr_block        = each.value.cidr
  tags = {
    Name = each.value.name
  }
}

resource "aws_subnet" "private" {
  for_each          = var.private_subnets
  vpc_id            = aws_vpc.study_infra.id
  availability_zone = each.value.az
  cidr_block        = each.value.cidr
  tags = {
    Name = each.value.name
  }
}

resource "aws_subnet" "secure" {
  for_each          = var.secure_subnets
  vpc_id            = aws_vpc.study_infra.id
  availability_zone = each.value.az
  cidr_block        = each.value.cidr
  tags = {
    Name = each.value.name
  }
}
