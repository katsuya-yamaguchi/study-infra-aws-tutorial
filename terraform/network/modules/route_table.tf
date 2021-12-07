##########################
# route table
##########################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.study_infra.id
  tags = {
    Name = "public"
  }
}

resource "aws_route_table" "private_a" {
  vpc_id = aws_vpc.study_infra.id
  tags = {
    Name = "private-a"
  }
}

resource "aws_route_table" "private_c" {
  vpc_id = aws_vpc.study_infra.id
  tags = {
    Name = "private-c"
  }
}

resource "aws_route_table" "secure" {
  vpc_id = aws_vpc.study_infra.id
  tags = {
    Name = "secure"
  }
}

##########################
# route
##########################
resource "aws_route" "to_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.study_infra.id
}

resource "aws_route" "private_a_to_nat_gateway" {
  count = var.public_subnets.public_a["nat_gateway_count"] == "0" ? 0 : 1

  route_table_id         = aws_route_table.private_a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.public_a[0].id
}

resource "aws_route" "private_c_to_nat_gateway" {
  count = var.public_subnets.public_c["nat_gateway_count"] == "0" ? 0 : 1

  route_table_id         = aws_route_table.private_c.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.public_c[0].id
}

##########################
# route tatable association
##########################
resource "aws_route_table_association" "public" {
  for_each       = var.public_subnets
  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private["private_a"].id
  route_table_id = aws_route_table.private_a.id
}

resource "aws_route_table_association" "private_c" {
  subnet_id      = aws_subnet.private["private_c"].id
  route_table_id = aws_route_table.private_c.id
}

resource "aws_route_table_association" "secure" {
  for_each       = var.secure_subnets
  subnet_id      = aws_subnet.secure[each.key].id
  route_table_id = aws_route_table.secure.id
}
