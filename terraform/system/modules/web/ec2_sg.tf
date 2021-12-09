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
