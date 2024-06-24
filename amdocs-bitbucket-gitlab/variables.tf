variable "acm_cert_domain" {
  description = "Domain of the certificate to use on the NLB TLS Listener. If NULL, NLB will use a TCP Listener instead."
  type        = string
  default     = null
}

variable "ami_id" {
  description = "AMI ID to deploy BitBucket Data Centre on."
  type        = string
}

variable "bitbucket_admin_user" {
  description = "Details for the admin user in BitBucket."
  type        = map(string)
}

variable "bitbucket_installer" {
  description = "Filename of the BitBucket installer."
  type        = string
}

variable "bitbucket_license" {
  description = "License key for BitBucket Data Cantre. Default is a trial license key."
  type        = string
}

variable "bitbucket_version" {
  description = "Version of BitBucket to be installed."
  type        = string
}

variable "customer_kms_key_arn" {
  description = "ARN of the CMK used for data encryption on EBS, RDS, S3 etc."
  type        = string
}

variable "deployment_role_arn" {
  description = "ARN of the IAM Role to assume to deploy the resources"
  type        = string
}

variable "ec2_subnet_ids" {
  description = "Subnet IDs to deploy EC2 into."
  type        = list(string)
}

variable "environment" {
  description = "Name of the environment."
  type        = string
}

variable "host_name" {
  description = "Host name for use with ACM and Route53."
  type        = string
}

variable "forward_proxy" {
  description = "Forward proxy for internet access, e.g. http://<IP/DNS>:<PORT>"
  type        = string
}

variable "forward_proxy_cidrs" {
  description = "Forward Proxy CIDRs for use in security groups."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type to use for BitBucket server."
  type        = string
}

variable "ldap_server_cidrs" {
  description = "LDAP server CIDRs for use in security groups."
  type        = string
}

variable "nlb_ingress_cidr" {
  description = "Allowed ingress CIDRs for the NLB security group."
  type        = list(string)
  default     = []
}

variable "nlb_subnets" {
  description = "Subnet IDs to deploy NLB into."
  type        = list(map(string))
}

variable "permissions_boundary_arn" {
  description = "ARN of the permissions boundary policy to attach to IAM roles."
  type        = string
  default     = null
}

variable "rds_instance_type" {
  description = "Instance type to use for RDS instances."
  type        = string
}

variable "rds_subnet_ids" {
  description = "Subnet IDs to deploy RDS resources into."
  type        = list(string)
}

variable "root_block_device_size" {
  description = "Size in GB for the EC2 instance root block device."
  type        = number
}

variable "route53_role_arn" {
  description = "ARN of the IAM role to assume to create Route53 records."
  type        = string
}

variable "route53_zone_id" {
  description = "Zone ID to create BitBucket Route53 records in."
  type        = string
}

variable "smtp_server_cidrs" {
  description = "SMTP server CIDRs for use in security groups."
  type        = string
}

variable "ssh_key_name" {
  description = "SSH key pair name for EC2 instance."
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "VPC ID to deploy resources into."
  type        = string
}

variable "zone_name" {
  description = "Route53 zone name."
  type        = string
}
