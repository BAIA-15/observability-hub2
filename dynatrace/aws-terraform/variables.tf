
# get the caller identity - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity

# The attribute `${data.aws_caller_identity.current.account_id}` will be current account number.
data "aws_caller_identity" "current" {}

# The attribue `${data.aws_iam_account_alias.current.account_alias}` will be current account alias
data "aws_iam_account_alias" "current" {}

# The attribute `${data.aws_region.current.name}` will be current region
data "aws_region" "current" {}

# Set as [local values](https://www.terraform.io/docs/configuration/locals.html)
locals {
  account_id    = data.aws_caller_identity.current.account_id
  account_alias = data.aws_iam_account_alias.current.account_alias
  region        = data.aws_region.current.name
}

# variables
variable "aws_cli_profile" {
  type        = string
  default     = "default"
  description = "The AWS CLI profile used in this deployment"
}

variable "aws_region" {
  type        = string
  default     = "ap-southeast-2"
  description = "The AWS region used in this deployment"
  nullable    = false
}

variable "tags" {
  type = object({
    o_b_bus-own    = string
    o_s_sra        = string
    o_s_app-class  = string
    o_t_app-role   = string
    o_t_env        = string
    o_t_app-plat   = string
    o_t_app        = string
    o_t_tech-own   = string
    o_b_cc         = string
    o_b_pri-own    = string
    o_b_project    = string
    o_b_bu         = string
    o_s_data-class = string
    o_t_app-own    = string
    o_t_dep-mthd   = string
    o_a_avail      = string
    o_t_lifecycle  = string
  })
  default     = null
  description = "Default resource tags"
}

# get the existing AWS resources

variable "main_vpc_id" {
  type        = string
  default     = "vpc-00000"
  description = "AWS VPC id used in this deployment"
}

variable "compute_subnet_1_id" {
  type        = string
  default     = "subnet-00000"
  description = "The first subnet id used in this deployment"
}

variable "compute_subnet_2_id" {
  type        = string
  default     = "subnet-00000"
  description = "The second subnet id used in this deployment"
}

variable "ec2_ami_id" {
  type        = string
  default     = "ami-00000"
  description = "EC2 AMI id"
}

variable "aws_ec2_instance_type" {
  type        = string
  default     = "t2.micro"
  description = "EC2 instance type"
}

variable "ec2_name_prefix" {
  type        = string
  default     = "dynatrace-oneagent"
  description = "Prefix used in EC2 resource names"
}

variable "iam_instance_profile_name" {
  type        = string
  default     = "application-observability-ec2-dynatrace-agent"
  description = "Amazon EC2 instance profile name"
}

variable "iam_role_vpc_flow_logs" {
  type        = string
  default     = "application-observability-vpc-flow-logs"
  description = "IAM role name for VPC flow logs to write to Amazon CloudWatch"
}

variable "aws_vpc_endpoints" {
  type        = list(string)
  default     = null
  description = "List of VPC endpoints"
}

# data sources

data "aws_vpc" "main" {
  id = var.main_vpc_id
}

data "aws_subnet" "compute_1" {
  id = var.compute_subnet_1_id
}

data "aws_subnet" "compute_2" {
  id = var.compute_subnet_2_id
}

data "aws_ami" "dynatrace" {
  filter {
    name   = "image-id"
    values = [var.ec2_ami_id]
  }
}

data "aws_ec2_instance_type" "dynatrace" {
  instance_type = var.aws_ec2_instance_type
}

data "aws_default_tags" "current" {}
