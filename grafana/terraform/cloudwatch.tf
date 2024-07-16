/*
# Data Source: aws_iam_policy_document - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document
data "aws_iam_policy_document" "vpc_flow_logs_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}
data "aws_iam_policy_document" "vpc_flow_logs_create_log_group" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]
    resources = ["*"]
  }
}

# Resource: aws_iam_role - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role
resource "aws_iam_role" "grafana_vpc_flow_logs" {
  name               = var.ec2_name_prefix
  assume_role_policy = data.aws_iam_policy_document.vpc_flow_logs_assume_role.json
}

# Resource: aws_iam_role_policy - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy
resource "aws_iam_role_policy" "grafana_vpc_flow_logs" {
  name   = var.ec2_name_prefix
  role   = aws_iam_role.grafana_vpc_flow_logs.id
  policy = data.aws_iam_policy_document.vpc_flow_logs_create_log_group.json
}
*/

data "aws_iam_role" "grafana_vpc_flow_logs" {
  name = var.iam_role_vpc_flow_logs
}

# Resource: aws_flow_log - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/flow_log
resource "aws_flow_log" "grafana" {
  iam_role_arn    = data.aws_iam_role.grafana_vpc_flow_logs.arn
  log_destination = aws_cloudwatch_log_group.grafana.arn
  traffic_type    = "ALL"
  vpc_id          = data.aws_vpc.main.id
}

# Resource: aws_cloudwatch_log_group - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group
resource "aws_cloudwatch_log_group" "grafana" {
  name              = "${var.ec2_name_prefix}_log_group"
  retention_in_days = 5
}
