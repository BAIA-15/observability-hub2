
# get the caller identity - https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# Set as [local values](https://www.terraform.io/docs/configuration/locals.html)
locals {
  account_id = data.aws_caller_identity.current.account_id
  caller_arn = data.aws_caller_identity.current.arn
}

# variables
variable "cluster_name" {
  type        = string
  default     = "observability-hub-grafana"
  description = "The AWS role ARN used in this deployment"
}

variable "kms_admin_role_arn" {
  type        = string
  default     = "arn:aws:iam::851725214198:role/aws-reserved/sso.amazonaws.com/ap-southeast-2/AWSReservedSSO_aws-it-observability-gnp-admin_989ac47dd987c39a"
  description = "The AWS role ARN used in this deployment"
}

# existing AWS resources

# get VPC id
variable "main_vpc_id" {
  type = string
  # default     = "vpc-09f66367832c81626"
  default     = "vpc-03acfc82685dd7a33"
  description = "The AWS VPC id used in this deployment"
}
# get subnet ids
variable "compute_subnet_1_id" {
  type = string
  # default     = "subnet-0956ea0317a3e43ed"
  default     = "subnet-0284b0ef91aea0ea6"
  description = "The first subnet id used in this deployment"
}
variable "compute_subnet_2_id" {
  type = string
  # default     = "subnet-0dc8294f868fec22c"
  default     = "subnet-0815036e894d811e5"
  description = "The second subnet id used in this deployment"
}

// stack variables
variable "ec2_name_prefix" {
  type        = string
  default     = "grafana-enterprise"
  description = "Prefix used in EC2 resource names"
}

# AMI name prefix - Red Hat Enterprise Linux SOE
variable "ec2_ami_id" {
  type        = string
  default     = "ami-086918d8178bfe266"
  description = "AMI id"
}
# default     = "RHEL8-SOE-*"

variable "ec2_instance_type" {
  type        = string
  default     = "t2.micro"
  description = "Amazon EC2 instance type"
}

variable "iam_instance_profile_name_grafana" {
  type        = string
  default     = "application-observability-ec2-grafana"
  description = "Amazon EC2 instance profile name"
}
