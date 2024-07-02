
data "aws_vpc" "main_vpc" {
  id = var.main_vpc_id
}

data "aws_subnet" "compute_subnet_1" {
  id = var.compute_subnet_1_id
}

data "aws_subnet" "compute_subnet_2" {
  id = var.compute_subnet_2_id
}

# Amazon EC2 security group
resource "aws_security_group" "grafana_ec2_sg" {
  name        = "grafana_ec2_sg"
  description = "Grafana EC2 security group - Managed by Terraform"
  vpc_id      = data.aws_vpc.main_vpc.id
  ingress     = []
  egress      = []
  tags = {
    Name = "grafana_ec2_sg"
  }
}
/*
resource "aws_security_group_rule" "allow_internal_alb" {
  type              = "ingress"
  from_port         = 3000
  to_port           = 3000
  protocol          = "TCP"
  cidr_blocks       = []
  security_group_id = aws_security_group.grafana_ec2_sg.id
}
*/

# Amazon EC2 launch template - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template 
resource "aws_launch_template" "grafana_ec2_launch_template" {
  name_prefix = "${var.ec2_name_prefix}-"
  iam_instance_profile {
    name = var.iam_instance_profile_name_grafana
  }
  image_id      = var.ec2_ami_id
  instance_type = var.ec2_instance_type
  # user_data       = file("files/install_grafana.sh")
  # key_name        = var.ec2_key_name
  vpc_security_group_ids = [aws_security_group.grafana_ec2_sg.id]
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "grafana_ec2"
    }
  }
}

# Amazon EC2 autoscaling group - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group
resource "aws_autoscaling_group" "grafana_ec2_autoscaling_group" {
  name             = "grafana_ec2_autoscaling_group"
  desired_capacity = 1
  min_size         = 1
  max_size         = 1
  launch_template {
    id      = aws_launch_template.grafana_ec2_launch_template.id
    version = "$Latest"
  }
  vpc_zone_identifier = [data.aws_subnet.compute_subnet_1.id, data.aws_subnet.compute_subnet_2.id]
  lifecycle {
    create_before_destroy = true
  }
}
