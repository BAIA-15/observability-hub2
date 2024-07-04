
# Amazon EC2 security group
resource "aws_security_group" "grafana" {
  name        = "grafana_ec2_sg"
  description = "Grafana EC2 security group - Managed by Terraform"
  vpc_id      = data.aws_vpc.main.id
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
resource "aws_launch_template" "grafana" {
  name_prefix = "${var.ec2_name_prefix}-"
  iam_instance_profile {
    name = var.iam_instance_profile_name
  }
  image_id      = data.aws_ami.grafana.id
  instance_type = data.aws_ec2_instance_type.grafana.id
  # user_data       = file("files/install_grafana.sh")
  vpc_security_group_ids = [aws_security_group.grafana.id]
  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "grafana_ec2"
    }
  }
}

# Amazon EC2 autoscaling group - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group
resource "aws_autoscaling_group" "grafana" {
  name             = "grafana_ec2_autoscaling_group"
  desired_capacity = 1
  min_size         = 1
  max_size         = 1
  launch_template {
    id      = aws_launch_template.grafana.id
    version = "$Latest"
  }
  vpc_zone_identifier = [data.aws_subnet.compute_1.id, data.aws_subnet.compute_2.id]
  lifecycle {
    create_before_destroy = true
  }
}
