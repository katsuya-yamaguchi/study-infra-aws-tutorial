output "vpc_id" {
  value = aws_vpc.study_infra.id
}

output "public_subnets_id" {
  value = [
    aws_subnet.public["public_a"].id,
    aws_subnet.public["public_c"].id
  ]
}
