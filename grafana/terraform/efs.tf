
# Amazon EC2 security group
resource "aws_security_group" "grafana_efs" {
  name        = "grafana_efs_sg"
  description = "Grafana EFS security group - Managed by Terraform"
  vpc_id      = data.aws_vpc.main.id
  tags = {
    Name = "${var.ec2_name_prefix}"
  }
}

# Resource: aws_efs_file_system - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system
resource "aws_efs_file_system" "grafana" {
  encrypted = true
  tags = {
    Name = "${var.ec2_name_prefix}"
  }
}

# Creating Mount target of EFS
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
