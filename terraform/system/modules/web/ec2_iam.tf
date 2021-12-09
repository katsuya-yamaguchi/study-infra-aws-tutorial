##########################
# IAM Policy
##########################
# ECSコンテナインスタンスの信頼ポリシー。
data "aws_iam_policy_document" "ecs_container_instance_web_sts" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# ECSコンテナインスタンス用に用意されているAWS管理ポリシー。
data "aws_iam_policy" "ecs" {
  name = "AmazonEC2ContainerServiceforEC2Role"
}

##########################
# IAM Role
##########################
resource "aws_iam_role" "ecs_container_instance_web" {
  name               = "ecs-container-instance-web"
  assume_role_policy = data.aws_iam_policy_document.ecs_container_instance_web_sts.json
}

resource "aws_iam_role_policy_attachment" "ecs_web" {
  role       = aws_iam_role.ecs_container_instance_web.name
  policy_arn = data.aws_iam_policy.ecs.arn
}


##########################
# Instance profile
##########################
resource "aws_iam_instance_profile" "ecs_web" {
  name = "ecs-web"
  role = aws_iam_role.ecs_container_instance_web.name
}
