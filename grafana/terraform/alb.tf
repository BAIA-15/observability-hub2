
# Amazon EC2 security group
resource "aws_security_group" "grafana_alb" {
  name        = "${var.ec2_name_prefix}_alb_sg"
  description = "${var.ec2_name_prefix} ALB security group - Managed by Terraform"
  vpc_id      = data.aws_vpc.main.id
  tags = {
    Name = "${var.ec2_name_prefix}_alb_sg"
  }
  lifecycle {
    create_before_destroy = true
  }
}

# Learn our public IP address
data "http" "icanhazip" {
  url = "http://icanhazip.com"
}

# Resource: aws_vpc_security_group_ingress_rule - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule
resource "aws_vpc_security_group_ingress_rule" "my_computer_to_alb" {
  description       = "ingress My Computer to ALB"
  security_group_id = aws_security_group.grafana_alb.id
  cidr_ipv4         = "${chomp(data.http.icanhazip.response_body)}/32"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
  tags = {
    Name = "${var.ec2_name_prefix}_computer_to_alb"
  }
}

# Resource: aws_vpc_security_group_egress_rule - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule
resource "aws_vpc_security_group_egress_rule" "alb_to_ec2" {
  description                  = "egress ALB to EC2"
  security_group_id            = aws_security_group.grafana_alb.id
  referenced_security_group_id = aws_security_group.grafana_ec2.id
  from_port                    = 3000
  ip_protocol                  = "tcp"
  to_port                      = 3000
  tags = {
    Name = "${var.ec2_name_prefix}_alb_to_ec2"
  }
}

# Resource: aws_lb - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb
resource "aws_lb" "grafana" {
  name               = var.ec2_name_prefix
  internal           = false # TODO - should be internal only
  load_balancer_type = "application"
  security_groups    = [aws_security_group.grafana_alb.id]
  subnets            = [data.aws_subnet.compute_1.id, data.aws_subnet.compute_2.id]
}

# Resource: aws_lb_listener - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener
resource "aws_lb_listener" "grafana" {
  load_balancer_arn = aws_lb.grafana.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.grafana.arn
  }
}

# Resource: aws_lb_target_group - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group
resource "aws_lb_target_group" "grafana" {
  name     = var.ec2_name_prefix
  port     = 3000
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.main.id
  health_check {
    path = "/api/health"
    port = 3000
  }
}

# Resource: aws_autoscaling_attachment - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_attachment
resource "aws_autoscaling_attachment" "grafana" {
  autoscaling_group_name = aws_autoscaling_group.grafana.id
  lb_target_group_arn    = aws_lb_target_group.grafana.arn
}
