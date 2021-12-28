resource "aws_alb" "web" {
  name               = "web"
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_web.id]

  # キーの文字列に「_」を含むリクエストヘッダーを除外する。こちらを悪用した攻撃を防ぐために有効。
  drop_invalid_header_fields = true

  access_logs {
    enabled = true
    bucket  = var.s3_logging_bucket
  }

  subnets                    = var.public_subnets_id
  idle_timeout               = 60
  enable_deletion_protection = false
  enable_http2               = true

  ip_address_type = "ipv4"

  # desync攻撃を防ぐためにデフォルト値を採用。
  desync_mitigation_mode = "defensive"
}

resource "aws_alb_listener" "web_https" {
  load_balancer_arn = aws_alb.web.arn
  port              = 443
  protocol          = "HTTPS"
  # 推奨のポリシーを使用。
  ssl_policy      = "ELBSecurityPolicy-2016-08"
  certificate_arn = var.ssl_certificate_study_infra_tk_arn

  default_action {
    type = "forward"
    forward {
      target_group {
        arn = aws_lb_target_group.web.arn
      }
      stickiness {
        enabled  = false
        duration = 604800
      }
    }
  }
}

resource "aws_alb_listener" "web_http" {
  load_balancer_arn = aws_alb.web.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = 443
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_target_group" "web" {
  name = "web"
  # 登録解除遅延の設定。登録を解除してから設定した秒数待って、解除が実行される。
  deregistration_delay = 300
  load_balancing_algorithm_type = "round_robin"
  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 30
    matcher             = "200-299"
    path                = "/"
    port                = 80
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 3
  }
  port                          = 8080
  protocol                      = "HTTP"
  protocol_version              = "HTTP2"
  slow_start                    = 0
  stickiness {
    enabled         = false
    type            = "lb_cookie"
    cookie_duration = 86400
  }
  vpc_id = var.vpc_id
}
