
# Amazon EC2 security group
resource "aws_security_group" "grafana_efs" {
  name        = "${var.ec2_name_prefix}_efs_sg"
  description = "${var.ec2_name_prefix} EFS security group - Managed by Terraform"
  vpc_id      = data.aws_vpc.main.id
  tags = {
    Name = "${var.ec2_name_prefix}_efs_sg"
  }
}

# Resource: aws_vpc_security_group_ingress_rule - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule
resource "aws_vpc_security_group_ingress_rule" "efs" {
  description       = "EFS mount target"
  security_group_id = aws_security_group.grafana_efs.id
  cidr_ipv4         = data.aws_vpc.main.cidr_block # TODO - inbound access from EC2 instances only (change to EC2 subnets)
  from_port         = 2049
  ip_protocol       = "tcp"
  to_port           = 2049
  tags = {
    Name = "${var.ec2_name_prefix}"
  }
}

# Resource: aws_efs_file_system - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system
resource "aws_efs_file_system" "grafana" {
  encrypted        = true
  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }
  tags = {
    Name = "${var.ec2_name_prefix}"
  }
}

# Resource: aws_efs_access_point - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_access_point
resource "aws_efs_access_point" "grafana" {
  file_system_id = aws_efs_file_system.grafana.id
  posix_user {
    gid = 1000 # the same gui/uid is used across each access point
    uid = 1000
  }
  root_directory {
    creation_info {
      owner_gid   = 1000
      owner_uid   = 1000
      permissions = 755
    }
    path = "/var/lib/grafana"
  }
  tags = {
    Name = "${var.ec2_name_prefix}"
  }
}

# Resource: aws_efs_mount_target - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target
resource "aws_efs_mount_target" "mount_1" {
  file_system_id  = aws_efs_file_system.grafana.id
  subnet_id       = data.aws_subnet.compute_1.id
  security_groups = [aws_security_group.grafana_efs.id]
}
resource "aws_efs_mount_target" "mount_2" {
  file_system_id  = aws_efs_file_system.grafana.id
  subnet_id       = data.aws_subnet.compute_2.id
  security_groups = [aws_security_group.grafana_efs.id]
}
