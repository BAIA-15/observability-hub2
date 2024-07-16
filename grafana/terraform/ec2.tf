
# Amazon EC2 security group
resource "aws_security_group" "grafana_ec2" {
  name        = "${var.ec2_name_prefix}_ec2_sg"
  description = "${var.ec2_name_prefix} EC2 security group - Managed by Terraform"
  vpc_id      = data.aws_vpc.main.id
  tags = {
    Name = "${var.ec2_name_prefix}_ec2_sg"
  }
}

# Resource: aws_vpc_security_group_ingress_rule - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule
# TODO - remove below in production - use SSM only instead
resource "aws_vpc_security_group_ingress_rule" "ssh_ec2_instance_connect" {
  description       = "SSH - EC2 Instance Connect"
  security_group_id = aws_security_group.grafana_ec2.id
  cidr_ipv4         = "13.239.158.0/29"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  tags = {
    Name = "${var.ec2_name_prefix}_ssh_ec2_instance_connect"
  }
}
resource "aws_vpc_security_group_ingress_rule" "ec2_to_alb" {
  description                  = "ALB ingress"
  security_group_id            = aws_security_group.grafana_ec2.id
  referenced_security_group_id = aws_security_group.grafana_alb.id
  from_port                    = 3000
  ip_protocol                  = "tcp"
  to_port                      = 3000
  tags = {
    Name = "${var.ec2_name_prefix}_ec2_to_alb"
  }
}

# Resource: aws_vpc_security_group_egress_rule - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule
resource "aws_vpc_security_group_egress_rule" "https_egress" {
  description       = "SSM required HTTPS 443 egress"
  security_group_id = aws_security_group.grafana_ec2.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
  tags = {
    Name = "${var.ec2_name_prefix}_https_egress"
  }
}
resource "aws_vpc_security_group_egress_rule" "all_traffic_egress" {
  description       = "All traffic egress"
  security_group_id = aws_security_group.grafana_ec2.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = -1
  tags = {
    Name = "${var.ec2_name_prefix}_all_traffic_egress"
  }
}

# Amazon EC2 launch template - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template 
resource "aws_launch_template" "grafana" {
  name        = var.ec2_name_prefix
  description = var.ec2_name_prefix
  iam_instance_profile {
    name = var.iam_instance_profile_name
  }
  image_id      = data.aws_ami.grafana.id
  instance_type = data.aws_ec2_instance_type.grafana.id
  metadata_options {
    http_endpoint          = "enabled"
    http_tokens            = "required"
    instance_metadata_tags = "enabled"
  }
  monitoring {
    enabled = true
  }
  update_default_version = true
  user_data = base64encode(
    file(
      "${path.module}/files/install_grafana_ubuntu.sh"
    )
  )
  vpc_security_group_ids = [aws_security_group.grafana_ec2.id]
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name    = "${var.ec2_name_prefix}"
      Created = timestamp()
    }
  }
  tag_specifications {
    resource_type = "volume"
    tags = merge(
      var.tags,
      {
        Name    = "${var.ec2_name_prefix}"
        Created = timestamp()
      }
    )
  }
}

# Amazon EC2 autoscaling group - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group
resource "aws_autoscaling_group" "grafana" {
  name                = "grafana_ec2_autoscaling_group"
  desired_capacity    = 1
  min_size            = 1
  max_size            = 1
  vpc_zone_identifier = [data.aws_subnet.compute_1.id, data.aws_subnet.compute_2.id]
  launch_template {
    id      = aws_launch_template.grafana.id
    version = "$Latest"
  }
  dynamic "tag" {
    for_each = data.aws_default_tags.current.tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }
  lifecycle {
    create_before_destroy = true
  }
}

# Resource: aws_autoscaling_notification - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_notification
# Amazon SNS notification options for Amazon EC2 Auto Scaling - https://docs.aws.amazon.com/autoscaling/ec2/userguide/ec2-auto-scaling-sns-notifications.html
resource "aws_autoscaling_notification" "example_notifications" {
  group_names = [
    aws_autoscaling_group.grafana.name
  ]
  notifications = [
    "autoscaling:EC2_INSTANCE_LAUNCH",
    "autoscaling:EC2_INSTANCE_TERMINATE",
    "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
    "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
    "autoscaling:TEST_NOTIFICATION"
  ]
  topic_arn = aws_sns_topic.grafana.arn
}
