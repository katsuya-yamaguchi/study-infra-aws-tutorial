resource "aws_vpc" "study_infra" {
  cidr_block       = "20.0.0.0/16"
  instance_tenancy = "default"

  # DNS解決を利用するかどうかの設定。
  # Route53でプライベートホストゾーンを使用する予定なので有効にする必要がある。
  enable_dns_support = true

  # パブリックIPアドレスを持つインスタンスにパブリックDNSを付与するかどうかの設定。
  # Route53でプライベートホストゾーンを使用する予定なので有効にする必要がある。
  enable_dns_hostnames = true

  # ipv6は使用しないため無効。
  assign_generated_ipv6_cidr_block = false
  tags = {
    Name = var.common_tags["System"]
  }
}
