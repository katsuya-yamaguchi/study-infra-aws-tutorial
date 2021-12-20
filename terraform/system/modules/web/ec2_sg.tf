##########################
# EC2 (ECSコンテナインスタンス)
##########################
resource "aws_security_group" "ecs_container_instance_web" {
  name   = "ecs-container-instance-web"
  vpc_id = var.vpc_id
  tags = {
    Name = "ecs-container-instance-web"
  }
}

resource "aws_security_group_rule" "ecs_container_instance_to_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.ecs_container_instance_web.id
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ecs_container_instance_from_alb_web" {
  type                     = "ingress"
  security_group_id        = aws_security_group.ecs_container_instance_web.id
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.alb_web.id
}

##########################
# ALB
##########################
resource "aws_security_group" "alb_web" {
  name   = "alb-web"
  vpc_id = var.vpc_id
  tags = {
    Name = "alb-web"
  }
}

resource "aws_security_group_rule" "alb_web_to_outbound" {
  type              = "egress"
  security_group_id = aws_security_group.alb_web.id
  from_port         = 0
  to_port           = 0
  protocol          = -1
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb_web_in_https" {
  type              = "ingress"
  security_group_id = aws_security_group.alb_web.id
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "alb_web_in_htttp" {
  type              = "ingress"
  security_group_id = aws_security_group.alb_web.id
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
}
