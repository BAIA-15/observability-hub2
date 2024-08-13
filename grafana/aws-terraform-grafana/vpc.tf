
# Resource: aws_security_group - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group
resource "aws_security_group" "vpce" {
  name        = "${var.ec2_name_prefix}_vpce_sg"
  description = "${var.ec2_name_prefix} VPCE security group - Managed by Terraform"
  vpc_id      = data.aws_vpc.main.id
  tags = {
    Name = "${var.ec2_name_prefix}_vpce_sg"
  }
}
# Resource: aws_vpc_security_group_ingress_rule - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule
resource "aws_vpc_security_group_ingress_rule" "vpce" {
  description       = "Allow subnets access"
  security_group_id = aws_security_group.vpce.id
  cidr_ipv4         = "13.239.158.0/29"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
  tags = {
    Name = "${var.ec2_name_prefix}_ssh_ec2_instance_connect"
  }
}

# Resource: aws_vpc_endpoint - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint
resource "aws_vpc_endpoint" "interface" {
  for_each            = toset(var.aws_vpc_endpoints)
  vpc_id              = data.aws_vpc.main.id
  private_dns_enabled = false
  service_name        = "com.amazonaws.${local.region}.${each.key}"
  security_group_ids = [
    aws_security_group.vpce.id,
  ]
  subnet_ids = [
    data.aws_subnet.compute_1.id,
    data.aws_subnet.compute_2.id
  ]
  vpc_endpoint_type = "Interface"
  tags = {
    Name = "vpce-${each.key}"
  }
}
