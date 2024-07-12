
# Amazon EC2 security group
resource "aws_security_group" "grafana_ec2" {
  name        = "grafana_ec2_sg"
  description = "Grafana EC2 security group - Managed by Terraform"
  vpc_id      = data.aws_vpc.main.id
  tags = {
    Name = "${var.ec2_name_prefix}"
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
    Name = "${var.ec2_name_prefix}"
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
}

# Amazon EC2 launch template - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template 
resource "aws_launch_template" "grafana" {
  name_prefix = "${var.ec2_name_prefix}-"
  iam_instance_profile {
    name = var.iam_instance_profile_name
  }
  image_id      = data.aws_ami.grafana.id
  instance_type = data.aws_ec2_instance_type.grafana.id
  # user_data       = file("files/install_grafana.sh")
  metadata_options {
    http_endpoint          = "enabled"
    http_tokens            = "required"
    instance_metadata_tags = "enabled"
  }
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
