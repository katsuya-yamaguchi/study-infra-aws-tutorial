resource "aws_autoscaling_group" "ecs" {
  name = "ecs-container-instance-web"
  max_size = 2
  min_size = 1
  desired_capacity = 1

  # EC2-Classicのみ使用可能。
  # availability_zones = var.az

  vpc_zone_identifier = var.public_subnets_id

  launch_template {
    id = aws_launch_template.web.id
    version = "$Default"
  }

  # 複数のインスタンスタイプ、AZを利用するEC2 オートスケール環境、キャパシティのリバランシング機能を利用する事で、 
  # 強制停止のリスクが高まったスポットインスタンスを自動で予防交換可能にする機能。
  # capacity_rebalance = ""

  # 起動してからスケーリングポリシーが適用されるまでの時間。起動しきる前にポリシーが適用されることを防ぐ役割がある。
  default_cooldown = 300

  # インスタンスを起動させてから、AutoScalingGroupに追加する前に前処理などをさせることが可能。今回は特にしないので無効。
  # https://dev.classmethod.jp/articles/auto-scaling-steps/#toc-9
  # initial_lifecycle_hook = {}

  # ヘルスチェックを開始するまえの猶予時間。
  health_check_grace_period = 300

  health_check_type = "EC2"

  # AutoScalingGroup内のインスタンスがterminateしていなくてもAutoScalingGroupを削除できるようになる設定。
  # 間違えて削除してしまった、など避けるために無効。
  force_delete = false
  
  # ALBの設定。
  target_group_arns = [aws_lb_target_group.web.arn]

  # 一番古いインスタンスから削除していくポリシーを選択。
  termination_policies = ["Default"]

  # プロセスの中断は不要なため無効。
  # https://docs.aws.amazon.com/ja_jp/autoscaling/ec2/userguide/as-suspend-resume-processes.html
  # suspended_processes = ""

  # ASGのメトリクス収集間隔。「1分間隔」しか設定することができない。
  metrics_granularity = "1Minute"

  # enabled_metrics = []

  # ASG内のインスタンスがhealthyになるまでTerraformが待つ時間。
  wait_for_capacity_timeout = "5m"

  # ELBのヘルスチェックで待機するhealtyなインスタンスの数。
  wait_for_elb_capacity = "1"

  protect_from_scale_in = false

  # ASGにロールはアタッチしないため無効。
  # service_linked_role_arn = ""

  # インスタンスの有効期限。0だと無効。
  max_instance_lifetime = 0

  # ASG内のインスタンスを更新して置き換えする機能。
  # https://docs.aws.amazon.com/ja_jp/autoscaling/ec2/userguide/asg-instance-refresh.html
  # instance_refresh = {}

  # depends_on = [
  #   aws_lb_target_group.web,
  # ]
}
