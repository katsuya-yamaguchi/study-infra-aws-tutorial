data "template_file" "userdata" {
  template = templatefile("${path.module}/template/userdata.sh", {
    CLUSTER_NAME = var.cluster_name
  })
}

resource "aws_launch_template" "web" {
  name = "ecs-container-instance-web"
  # 起動テンプレートにデフォルトのバージョンを設定することが可能。バージョンを指定しない場合、デフォルトのバージョンでインスタンスが起動する。
  # default_version = ""

  # 起動テンプレートの更新時にデフォルトのバージョンをアップするかどうかの設定。default_versionと競合するため、どちらか設定する。
  # 今回はこちらを採用。
  update_default_version = true

  block_device_mappings {
    ebs {
      delete_on_termination = true
      encrypted             = false
      volume_size           = 20
      volume_type           = "gp3"
    }
  }

  # キャパシティ予約の設定。今回は使用しないので無効。
  # https://blog.serverworks.co.jp/ec2-capacity-reservations
  # capacity_reservation_specification = {}

  # インスタンスタイプがT系の場合、CPUクレジットを無制限にするか標準にするかの設定
  # 無制限だと課金の可能性があるため、標準を選択。
  # https://dev.classmethod.jp/articles/ec2-t-or-m/#toc-4
  credit_specification {
    cpu_credits = "standard"
  }

  # trueにすると終了保護が有効化される。今回は無効。
  disable_api_termination = false

  ebs_optimized = false

  # Elastic Graphicsは使用しないため無効。
  # https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/WindowsGuide/elastic-graphics.html#elastic-gpus-basics
  # elastic_gpu_specifications = {}

  # EIは使用しないため無効。
  # https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/UserGuide/elastic-inference.html
  # elastic_inference_acceleratork = {}

  iam_instance_profile {
    arn = aws_iam_instance_profile.ecs_web.arn
  }

  # パラメータストアから取得した2021/11/25時点のAMI。
  # https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/ecs-optimized_AMI.html
  image_id = var.ami_id

  instance_initiated_shutdown_behavior = "stop"

  # スポットインスタンスを利用しないため無効。
  # instance_market_options = {}

  instance_type = var.instance_type
  key_name      = var.key_name

  # ソフトウェアベンダーとの契約ライセンスの条項を設定することが可能。今回は使用しないため無効。
  # https://docs.aws.amazon.com/ja_jp/license-manager/latest/userguide/create-license-configuration.html
  # license_specification = {}

  # インスタンスメタデータの利用に関する設定。
  metadata_options {
    http_endpoint = "enabled"
    # セキュアなIMDSv2しか利用できないようにする。
    http_tokens = "required"
    # コンテナ環境の場合、デフォルトの1だとコンテナ→インスタンスとなり応答が返ってこない。そのため２を設定する。
    # https://docs.aws.amazon.com/ja_jp/AWSEC2/latest/WindowsGuide/instancedata-data-retrieval.html
    http_put_response_hop_limit = 2
    http_protocol_ipv6          = "disabled"
  }

  # 拡張モニタリングの設定。
  monitoring {
    enabled = false
  }

  # network_interfaces {
  #   associate_public_ip_address = false
  #   delete_on_termination       = true
  # }
  vpc_security_group_ids = [
    aws_security_group.ecs_container_instance_web.id
  ]
  user_data = base64encode(data.template_file.userdata.rendered)

  # OS停止時にメモリの値をディスクに書き出し、OS起動時にディスクから読み出しメモリにキャッシュする機能。
  hibernation_options {
    configured = false
  }

  enclave_options {
    enabled = false
  }
}
