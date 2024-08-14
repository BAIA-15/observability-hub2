
# Resource: aws_security_group - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "elastic_ec2" {
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
  security_group_id = aws_security_group.elastic_ec2.id
  cidr_ipv4         = "13.239.158.0/29"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  tags = {
    Name = "${var.ec2_name_prefix}_ssh_ec2_instance_connect"
  }
}

# Resource: aws_vpc_security_group_egress_rule - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule
resource "aws_vpc_security_group_egress_rule" "https_egress" {
  description       = "SSM required HTTPS 443 egress"
  security_group_id = aws_security_group.elastic_ec2.id
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
  security_group_id = aws_security_group.elastic_ec2.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = -1
  tags = {
    Name = "${var.ec2_name_prefix}_all_traffic_egress"
  }
}

# Amazon EC2 launch template - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template 
resource "aws_launch_template" "elastic" {
  name        = var.ec2_name_prefix
  description = var.ec2_name_prefix
  iam_instance_profile {
    name = var.iam_instance_profile_name
  }
  image_id      = data.aws_ami.elastic.id
  instance_type = data.aws_ec2_instance_type.elastic.id
  metadata_options {
    http_endpoint          = "enabled"
    http_tokens            = "required"
    instance_metadata_tags = "enabled"
  }
  monitoring {
    enabled = true
  }
  network_interfaces {
    associate_public_ip_address = false
    description                 = "No public IP address"
    security_groups             = [aws_security_group.elastic_ec2.id]
  }
  update_default_version = true
  user_data = base64encode(
    templatefile(
      "${path.module}/files/install_elastic_ubuntu.tftpl",
      {
      }
    )
  )
  # vpc_security_group_ids = [aws_security_group.elastic.id]
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

# Resource: aws_instance - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance

resource "aws_instance" "elastic" {
  launch_template {
    id      = aws_launch_template.elastic.id
    version = "$Latest"
  }
}
