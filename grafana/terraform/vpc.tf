
# aws_vpc_endpoint - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint

resource "aws_vpc_endpoint" "interface" {
  for_each          = toset(var.aws_vpc_endpoints)
  vpc_id            = data.aws_vpc.main.id
  service_name      = "com.amazonaws.${local.region}.${each.key}"
  vpc_endpoint_type = "Interface"
  tags = {
    Name = "interface-${each.key}"
  }
}
